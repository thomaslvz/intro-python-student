"""
Ne pas modifier ce fichier. Il contient les tests automatisés pour
guider les étudiant.e.s dans les notebook.
"""

import traceback
import numpy as np

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
def check_mean_revenue(r):
    assert isinstance(r, np.float64), (
        "La valeur de mean_revenue doit être calculée avec pandas ou NumPy..."
    )
    assert r == 122, "Le chiffre d'affaire moyen devrait valoir 122 k€."


@test_checker_var
def check_companies_shape(companies_shape):
    assert tuple(companies_shape) == (4, 3), (
        "Le DataFrame doit contenir 4 lignes et 3 colonnes."
    )


@test_checker_var
def check_companies(c):
    assert tuple(c.shape) == (4, 4), (
        "Avez-vous ajouté la colonne `revenue_per_employee` ?"
    )
    assert "revenue_per_employee" in c.columns, (
        "Avez-vous ajouté la colonne `revenue_per_employee` sous le bon nom ?"
    )
    assert np.isclose(c["revenue_per_employee"], c["revenue"] / c["employees"]).all(), (
        "Le revenu par employé n'est pas bien calculé..."
    )
    assert c.loc["Delta", "city"].lower() == "marseille", (
        "Avez-vous modifié la ville de l'entreprise Delta ?"
    )


@test_checker_var
def check_sales(c):
    assert tuple(c.shape) == (12, 5), (
        "Avez-vous ajouté la colonne `revenue above mean?` ?"
    )
    assert "revenue above mean?" in c.columns, (
        "Avez-vous ajouté la colonne `revenue above mean?` sous le bon nom ?"
    )
    mean_Lyon = c.loc[c["store"] == "Lyon"]["revenue"].mean()
    mean_Paris = c.loc[c["store"] == "Paris"]["revenue"].mean()
    for index, row in c.iterrows():
        mean = mean_Lyon if row["store"] == "Lyon" else mean_Paris
        assert (row["revenue"] > mean) == row["revenue above mean?"], (
            f"La valeur de `revenue above mean?` ne semble pas bonne sur la ligne d'index {index}"
        )


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
