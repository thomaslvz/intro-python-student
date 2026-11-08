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
def check_is_admitted(a):
    assert isinstance(a, np.ndarray), (
        "La variable 'is_admitted' doit être un ndarray, construit avec NumPy en testant si les notes dépassent 10."
    )
    assert a.dtype == "bool", (
        "'is_admitted' doit contenir des True et des False selon la valeur de chaque note."
    )
    assert (
        a
        == np.array(
            [
                [True, False, True, False, True, False, True, True],
                [True, True, True, False, False, True, True, True],
            ]
        )
    ).all(), (
        "Avez-vous utilisé un test vérifiant si chaque note est supérieure ou égale à 10 ?"
    )


@test_checker_var
def check_notes_admitted(a):
    assert (a == np.array([12, 17, 14, 18, 11, 15, 13, 16, 12, 14, 10])).all(), (
        "Le tableau des notes admises est erroné."
    )


@test_checker_var
def check_notes_failed(a):
    assert (a == np.array([8, 5, 9, 9, 6])).all(), (
        "Le tableau des notes non admises est erroné."
    )


@test_checker_var
def check_bonus(a):
    assert isinstance(a, np.ndarray), "La variable 'bonus_notes' doit être un ndarray."
    assert np.array_equal(
        a, np.array([[12, 10, 17, 7, 14, 11, 18, 11], [15, 13, 16, 11, 8, 12, 14, 10]])
    ), "Le tableau 'bonus_notes' ne contient pas les bonnes notes."


@test_checker_var
def check_is_hot(is_hot, data):
    assert isinstance(is_hot, np.ndarray), "is_hot doit être un array NumPy."
    assert is_hot.dtype == bool, "is_hot doit contenir des booléens."
    assert is_hot.shape == data.shape, (
        "Le masque doit avoir la même dimension que data."
    )
    assert np.array_equal(is_hot, data > 30), (
        "Le masque doit tester les températures strictement supérieures à 30°C."
    )


@test_checker_var
def check_warm_temps(warm_temps, data):
    expected = data[(data >= 25) & (data <= 30)]
    assert np.array_equal(warm_temps, expected), (
        "Vérifier les deux bornes du filtre (25°C et 30°C inclus)."
    )


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
