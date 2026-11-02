"""
Ne pas modifier ce fichier. Il contient les tests automatisés pour
guider les étudiant.e.s dans les notebook.
"""

import traceback
from IPython import get_ipython
import numpy as np

SUCCESS_MSG = "✅ Tout va bien, vous pouvez continuer."
ERROR_MSG = """
❌ Vous n'avez pas correctement répondu à la question précédente.
Avez-vous testé votre code sur un/des exemple(s) ?
Si vous n'arrivez pas à corriger votre code, demandez autour de vous
ou appelez l'enseignant.
"""


def test_checker_func(func):
    def wrapper(*args, details=True, **kwargs):
        try:
            func(*args, **kwargs)
            print(SUCCESS_MSG)
        except AssertionError as error:
            print(ERROR_MSG)

            if details:
                if str(error):
                    print(f"\n💡 Indice : {error}")
                else:
                    print("\nDétails de l'erreur :")
                    frame = traceback.extract_tb(traceback.sys.exc_info()[2])[-1]
                    tested_function = args[0].__name__
                    print(
                        f"Test échoué : {frame.line.replace('f(', f'{tested_function}(')}"
                    )
        except Exception:
            print(ERROR_MSG)

    return wrapper


def test_checker_var(var):
    def wrapper(*args, details=True, **kwargs):
        try:
            var(*args, **kwargs)
            print(SUCCESS_MSG)
        except AssertionError as error:
            print(ERROR_MSG)

            if details:
                if str(error):
                    print(f"💡 Indice : {error}")
                else:
                    print("💡 Une des conditions du test n'est pas satisfaite.")
        except:
            print(ERROR_MSG)

    return wrapper


@test_checker_var
def check_q1(v):
    assert v == 19, "q1 doit valoir 19..."
    assert isinstance(v, np.int64), (
        "La variable q1 doit être sélectionnée depuis la matrice Y."
    )


@test_checker_var
def check_q2(v):
    assert isinstance(v, np.ndarray), (
        "La variable q2 doit être un array correspondant à une ligne de Y."
    )
    assert v.shape == (5,), "La variable q2 doit contenir exactement 5 éléments."
    assert (v == np.array([5, 6, 7, 8, 9])).all(), (
        "Avez vous bien sélectionné la 2e ligne (celle qui commence par 5) ?"
    )


@test_checker_var
def check_q34(q3, q4):
    assert isinstance(q3, np.ndarray), "Il y a une erreur sur q3."
    assert np.array_equal(q3, np.array([3, 8, 13, 18, 23])), "Il y a une erreur sur q3."

    assert isinstance(q4, np.ndarray), "Il y a une erreur sur q4."
    assert np.array_equal(q4, np.array([[6, 7, 8], [11, 12, 13], [16, 17, 18]])), (
        "Il y a une erreur sur q4."
    )


def check_import():
    ipython = get_ipython()

    if ipython is None:
        print("Cette fonction doit être appelée depuis Jupyter.")
        return

    notebook_ns = ipython.user_ns

    if "np" in notebook_ns:
        print(SUCCESS_MSG)
    else:
        print(" ❌ Vérifiez dans le cours comment doit être importé Numpy.")


@test_checker_var
def check_xy(X, Y):
    assert np.array_equal(X, np.array([[1, 2, 3], [4, 5, 6], [7, 8, 9]])), (
        "Il y a une erreur sur X."
    )
    assert np.array_equal(Y, np.array([[10, 11, 12], [13, 14, 15], [16, 17, 18]])), (
        "Il y a une erreur sur Y."
    )


@test_checker_var
def check_A(v):
    assert isinstance(v, np.ndarray), "A n'est pas un array."
    assert np.array_equal(v, np.array([[11, 13, 15], [17, 19, 21], [23, 25, 27]])), (
        "La matrice A n'est pas correcte."
    )


@test_checker_var
def check_B(v):
    assert isinstance(v, np.ndarray), "B n'est pas un array."
    assert np.array_equal(v, np.array([[5, 10, 15], [20, 25, 30], [35, 40, 45]])), (
        "La matrice B n'est pas correcte."
    )


@test_checker_var
def check_C(v):
    assert isinstance(v, np.ndarray), "C n'est pas un array."
    assert np.array_equal(
        v, np.array([[100, 121, 144], [169, 196, 225], [256, 289, 324]])
    ), "La matrice C n'est pas correcte."


@test_checker_var
def check_D(v):
    assert isinstance(v, np.ndarray), "D n'est pas un array."
    assert np.isclose(
        v, np.array([[10.0, 5.5, 4.0], [3.25, 2.8, 2.5], [2.28571429, 2.125, 2.0]])
    ).all(), "La matrice D n'est pas correcte."


@test_checker_var
def check_temp_elev(v):
    assert isinstance(v, np.ndarray), "temp_elevation n'est pas un array."
    assert np.isclose(
        v, np.array([1.59975342, 2.1009589, 2.00531507, 1.9050137, 1.64126027])
    ).all(), "Les valeurs de temp_elevation ne sont pas bonnes."
