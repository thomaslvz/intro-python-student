import importlib
import importlib.util
import json
import os
import shutil
import subprocess
import sys


# ============================================================
# Configuration
# ============================================================

sys.stdout.reconfigure(encoding="utf-8")
sys.stderr.reconfigure(encoding="utf-8")

EXPECTED_CONDA_ENVIRONMENT = "intro-python-feg-l3"
EXPECTED_PYTHON_VERSION = "3.12"

EXPECTED_PACKAGES = {
    "numpy": "2.5.3",
    "pandas": "3.0.5",
    "matplotlib": "3.11.2",
    "statsmodels": "0.15.0",
    "jupyterlab": "4.6.3",
}

EXPECTED_JUPYTER_KERNEL = "intro-python-feg-l3"


# ============================================================
# Checks
# ============================================================

def check_environment():
    """Check the active Conda environment."""
    active = os.environ.get("CONDA_DEFAULT_ENV")

    print("Conda environment")
    print(f"  Active:   {active}")
    print(f"  Expected: {EXPECTED_CONDA_ENVIRONMENT}")

    if active == EXPECTED_CONDA_ENVIRONMENT:
        print("  [OK]")
        return True

    print("  [ERROR] Wrong Conda environment.")
    return False


def check_python():
    """Check the Python version and executable."""
    installed = f"{sys.version_info.major}.{sys.version_info.minor}"

    print("Python")
    print(f"  Installed:  {installed}")
    print(f"  Expected:   {EXPECTED_PYTHON_VERSION}")
    print(f"  Executable: {sys.executable}")

    if installed == EXPECTED_PYTHON_VERSION:
        print("  [OK]")
        return True

    print("  [ERROR] Wrong Python version.")
    return False


def check_package(package_name, expected_version):
    """Check whether a package is installed with the expected version."""
    try:
        package = importlib.import_module(package_name)
        installed = package.__version__

        print(package_name)
        print(f"  Installed: {installed}")
        print(f"  Expected:  {expected_version}")

        if installed == expected_version:
            print("  [OK]")
            return True

        print("  [ERROR] Wrong version.")
        return False

    except ImportError:
        print(package_name)
        print("  [ERROR] Package not installed.")
        return False


def check_jupyter_command():
    """Check whether the Jupyter command is available."""
    executable = shutil.which("jupyter")

    print("Jupyter command")

    if executable is None:
        print("  [ERROR] Jupyter command not found.")
        return False

    print(f"  Executable: {executable}")
    print("  [OK]")
    return True

def check_jupyter_kernel():
    """Check Jupyter, ipykernel and kernel consistency with the current Python."""
    print("Jupyter kernel")

    current_python = os.path.normcase(
        os.path.realpath(os.path.abspath(sys.executable))
    )

    print(f"  Current Python: {sys.executable}")
    print(f"  Python prefix:  {sys.prefix}")
    
    # ------------------------------------------------------------------
    # 1. Check Jupyter executable
    # ------------------------------------------------------------------
    jupyter_executable = shutil.which("jupyter")

    if jupyter_executable is None:
        print("  [ERROR] Jupyter command not found.")
        return False

    jupyter_executable = os.path.normcase(
        os.path.realpath(os.path.abspath(jupyter_executable))
    )

    print(f"  Jupyter:        {jupyter_executable}")

    # ------------------------------------------------------------------
    # 2. Check ipykernel in the current Python environment
    # ------------------------------------------------------------------
    try:
        ipykernel_spec = importlib.util.find_spec("ipykernel")
    except (ImportError, ModuleNotFoundError):
        ipykernel_spec = None

    if ipykernel_spec is None:
        print("  [ERROR] ipykernel is not installed in the current environment.")
        return False

    try:
        import ipykernel

        ipykernel_version = getattr(ipykernel, "__version__", "unknown")
        ipykernel_path = os.path.normcase(
            os.path.realpath(os.path.abspath(ipykernel.__file__))
        )

    except (ImportError, AttributeError):
        print("  [ERROR] Unable to import ipykernel.")
        return False

    print(f"  ipykernel:      {ipykernel_version}")
    print(f"  ipykernel path: {ipykernel_path}")

    # Check that ipykernel belongs to the current Python environment.
    environment_prefix = os.path.normcase(
        os.path.realpath(os.path.abspath(sys.prefix))
    )

    try:
        ipykernel_environment = os.path.commonpath(
            [environment_prefix, ipykernel_path]
        ) == environment_prefix
    except ValueError:
        # Can happen when paths are on different drives on Windows.
        ipykernel_environment = False

    if not ipykernel_environment:
        print("  [WARNING] ipykernel does not appear to belong to the current")
        print("            Python environment.")
        
        
    # ------------------------------------------------------------------
    # 3. Retrieve Jupyter kernelspecs
    # ------------------------------------------------------------------
    try:
        result = subprocess.run(
            [jupyter_executable, "kernelspec", "list", "--json"],
            capture_output=True,
            text=True,
            check=True,
        )

        kernels = json.loads(result.stdout).get("kernelspecs", {})

    except subprocess.CalledProcessError as exc:
        print("  [ERROR] Unable to retrieve Jupyter kernels.")
        if exc.stderr:
            print(f"          {exc.stderr.strip()}")
        return False

    except json.JSONDecodeError:
        print("  [ERROR] Jupyter returned invalid kernel information.")
        return False

    # ------------------------------------------------------------------
    # 4. Find a kernel using exactly the current Python executable
    # ------------------------------------------------------------------
    matching_kernels = []

    for kernel_name, kernel_info in kernels.items():
        spec = kernel_info.get("spec", {})
        kernel_argv = spec.get("argv", [])

        if not kernel_argv:
            continue

        kernel_python = kernel_argv[0]

        # A kernel must explicitly reference a Python executable.
        if not isinstance(kernel_python, str):
            continue

        if not os.path.isabs(kernel_python):
            continue

        normalized_kernel_python = os.path.normcase(
            os.path.realpath(os.path.abspath(kernel_python))
        )

        if normalized_kernel_python != current_python:
            continue

        # Verify that the executable actually exists.
        if not os.path.isfile(kernel_python):
            continue

        # Verify that this is an ipykernel launcher.
        if "ipykernel_launcher" not in kernel_argv:
            continue

        matching_kernels.append(
            {
                "name": kernel_name,
                "display_name": spec.get("display_name", ""),
                "argv": kernel_argv,
                "resource_dir": kernel_info.get("resource_dir", ""),
            }
        )

    # ------------------------------------------------------------------
    # 5. Report result
    # ------------------------------------------------------------------
    if matching_kernels:
        print("  Matching kernels:")

        for kernel in matching_kernels:
            print(f"    - {kernel['name']}")
            print(f"      Display name: {kernel['display_name']}")
            print(f"      Python:       {kernel['argv'][0]}")

        print("  [OK] Jupyter kernel is consistent with the current environment.")
        return True

    # ------------------------------------------------------------------
    # 6. Diagnostic information when no matching kernel exists
    # ------------------------------------------------------------------
    print("  [ERROR] No valid Jupyter kernel uses the current Python executable.")
    print("  Available kernels:")

    if not kernels:
        print("    None")
    else:
        for kernel_name, kernel_info in kernels.items():
            spec = kernel_info.get("spec", {})
            kernel_argv = spec.get("argv", [])
            display_name = spec.get("display_name", "")

            if kernel_argv:
                kernel_python = kernel_argv[0]

                if isinstance(kernel_python, str):
                    normalized_kernel_python = os.path.normcase(
                        os.path.realpath(os.path.abspath(kernel_python))
                    )
                    is_current = normalized_kernel_python == current_python
                else:
                    is_current = False

                marker = " <-- CURRENT PYTHON" if is_current else ""

                print(
                    f"    - {kernel_name}: "
                    f"{kernel_python} "
                    f"({display_name}){marker}"
                )
            else:
                print(f"    - {kernel_name}: no executable found")

    print()
    print("  To create a kernel for the current environment, run:")
    print(f"    {sys.executable} -m ipykernel install --user")

    return False

# ============================================================
# Setup check
# ============================================================

print("=" * 60)
print("Intro à Python - Setup Check")
print("=" * 60)
print()

all_ok = True

all_ok = check_environment() and all_ok
print()

all_ok = check_python() and all_ok
print()

all_ok = check_jupyter_command() and all_ok
print()

all_ok = check_jupyter_kernel() and all_ok
print()

for package_name, expected_version in EXPECTED_PACKAGES.items():
    all_ok = check_package(package_name, expected_version) and all_ok
    print()

print("=" * 60)

if all_ok:
    print("SETUP OK")
    print("Your Python environment is ready.")
else:
    print("SETUP ERROR")
    print("Please check your installation or contact the instructor.")

print("=" * 60)

if not all_ok:
    sys.exit(1)
