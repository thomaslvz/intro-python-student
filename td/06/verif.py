"""
Ne pas modifier ce fichier. Il contient les tests automatisés pour
guider les étudiant.e.s dans les notebook.
"""

import traceback
import pandas as pd

SUCCESS_MSG = "✅ Tout va bien, vous pouvez continuer."
ERROR_MSG = """❌ Vous n'avez pas correctement répondu à la question précédente.
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
                    tested_function = func.__name__
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
        except Exception:
            print(ERROR_MSG)

    return wrapper


@test_checker_var
def check_titanic_shape(titanic_shape):
    assert tuple(titanic_shape) == (891, 12), (
        "Le fichier train.csv attendu contient 891 lignes et 12 colonnes."
    )


@test_checker_var
def check_survival_rate(survival_rate):
    assert abs(float(survival_rate) - 0.3838383838) < 1e-6, (
        "Vérifier le calcul de la proportion : la moyenne de Survived donne le taux de survie."
    )


@test_checker_var
def check_nas(t):
    assert tuple(t.shape) == (712, 12)


@test_checker_var
def check_columns(t):
    assert (t.columns == ["Name", "Age", "Sex", "Fare", "Survived", "Pclass"]).all(), (
        "Vérifiez vos colonnes actuellement avec .columns. Vérifiez aussi l'ordre des colonnes"
    )


@test_checker_var
def check_sorting(t):
    assert t.head(3).Fare.mean() == 512.3292, "Le DataFrame titanic doit être trié."
    assert t.tail(5).Fare.mean() == 0, "Le DataFrame titanic doit être trié."


@test_checker_var
def check_grouped(t):
    assert t.shape[0] == 2, "Le tableau `grouped` doit avoir 2 lignes (female et male)."
    assert t.shape[1] == 3, (
        "Le tableau `grouped` doit avoir 3 colonnes, pour les 3 calculs demandés."
    )
    assert t.sum().sum() - 1058.4718183 < 0.0001, (
        "Le tableau a la bonne forme mais les valeurs sont erronées. Avez-vous bien fait les 3 calculs demandés ?"
    )


@test_checker_var
def check_passclass(s):
    assert isinstance(s, pd.Series), (
        "La variable `pass_per_class` doit être une Series."
    )
    assert s.sum() == 712, (
        "Il y a 712 passagers en tout dans le DataFrame titanic, et ce n'est pas le cas dans `pass_per_class`."
    )
    assert (s.index == [1, 2, 3]).all(), (
        "Il faut faire un groupby par classe (Pclass) ici."
    )
