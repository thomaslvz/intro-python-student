"""
Ne pas modifier ce fichier. Il contient les tests automatisés pour
guider les étudiant.e.s dans les notebook.
"""

import traceback

SUCCESS_MSG = "✅ Tout va bien, vous pouvez continuer."
ERROR_MSG = """
❌ Vous n'avez pas correctement répondu à la question précédente.
Si vous n'arrivez pas à corriger votre code, demandez autour de vous
ou appelez l'enseignant.
"""


def test_checker(func):
    def wrapper(*args, details=True, **kwargs):
        try:
            func(*args, **kwargs)
            print(SUCCESS_MSG)
        except AssertionError:
            print(ERROR_MSG)
            if details:
                print("\nDétails de l'erreur :")
                frame = traceback.extract_tb(traceback.sys.exc_info()[2])[
                    -1
                ]  # get line of error
                tested_function = args[0].__name__  # get function name
                print(
                    f"Test échoué : {frame.line.replace('f(', f'{tested_function}(')}"
                )
        except:
            print(ERROR_MSG)

    return wrapper


@test_checker
def check_calculate_power(f):
    assert f(2, 0) == 1
    assert f(5, 2) == 25
    assert f(3, 3) == 27
    assert f(3, 4) == 81


@test_checker
def check_elasticity(f):
    assert abs(f(100, 95, 10, 11) - (-0.5)) < 1e-9


@test_checker
def check_separate_tags(f):
    assert f("python data science") == "python, data, science"
    assert f("Bonjour merci") == "Bonjour, merci"
