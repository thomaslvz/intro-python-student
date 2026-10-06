"""
Ne pas modifier ce fichier. Il contient les tests automatisés pour
guider les étudiant.e.s dans les notebook.
"""

import traceback
import numpy as np

SUCCESS_MSG = "✅ Tout va bien, vous pouvez continuer."
ERROR_MSG = """
❌ Vous n'avez pas correctement répondu à la question précédente.
Si vous n'arrivez pas à corriger votre code, demandez autour de vous
ou appelez l'enseignant.
"""


def test_checker_func(func):
    def wrapper(*args, details=False, **kwargs):
        try:
            func(*args, **kwargs)
            print(SUCCESS_MSG)
        except AssertionError:
            print(ERROR_MSG)

            if details:
                print("\nDétails de l'erreur :")
                frame = traceback.extract_tb(traceback.sys.exc_info()[2])[-1]
                tested_function = args[0].__name__
                print(
                    f"Test échoué : {frame.line.replace('f(', f'{tested_function}(')}"
                )
        except:
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
def check_sells(s):
    assert s == 12_238.56


@test_checker_var
def check_revenue(rev):
    assert rev == 12238.56


@test_checker_var
def check_bilan(t):
    assert t in [
        "Smartphone: 15 units - Revenue: 12238.56€",
        "Smartphone: 15 units - Revenue: 12238.56 €",
    ]


@test_checker_var
def check_list_1(lis):
    assert len(lis) == 60, "La liste doit être de longueur 60."
    assert lis[42] == 1050, (
        "Le 43e terme est le terme d'indice 42, et il doit valoir 1050."
    )
    assert np.array(lis).sum() == 78080 - 900 + 1050, (
        "Avez vous modifié d'autres termes que le 43e ?"
    )


@test_checker_var
def check_list_2(lis):
    assert len(lis) == 61, (
        "Il faut ajouter un terme à la liste,\ncelle-ci doit avoir une longueur de 61."
    )
    assert lis[-1] == 1320, "Le dernier terme de la liste\ndoit valoir 1320"
    assert np.array(lis).sum() == 78080 - 900 + 1050 + 1320, (
        "La liste daily_sales ne contient pas\nles bonnes valeurs. Avez vous bien modifié le\n43e terme (question précédente) ET ajouté un dernier terme ?"
    )


check_list_3 = check_list_1


@test_checker_var
def check_list_4(lis):
    assert lis == [
        1490,
        1130,
        1680,
        970,
        1380,
    ], (
        "Un slicer a la syntaxe [start:stop].\nPar exemple, avec le slicer [4:8] on obtient les termes d'indices\n4 (5e jour) à 7 (car 8 est non inclus) : donc les ventes du (5e au 8e jour)."
    )


@test_checker_var
def check_list_5(lis):
    assert lis == [1470, 990, 1360, 850, 920, 1650, 980, 1570, 1030, 1610], (
        "Le slicer [4:] retourne tous les termes\nà partir de celui d'indice 4 (inclus)."
    )


@test_checker_var
def check_list_6(lis):
    assert lis == [
        910,
        1130,
        1260,
        1310,
        1230,
        1280,
        1390,
        1460,
        1350,
        1540,
        990,
        980,
    ], "La syntaxe générale d'un slicer est [start:stop:step]."


@test_checker_var
def check_dict_1(d):
    assert d != {
        "name": "EcoTech",
        "sector": "Technology",
        "employees": 42,
        "revenue": 1250000,
    }, "Il faut modifier la valeur correspondant à la clé 'employees'."
    assert d == {
        "name": "EcoTech",
        "sector": "Technology",
        "employees": 45,
        "revenue": 1250000,
    }, "L'entreprise compte désormais 45 employés."


@test_checker_var
def check_dict_2(d):
    assert d.get("city", False), (
        "Le dictionnaire actuel ne comporte pas d'élément de clé 'city'."
    )
    assert d.get("city", False).lower() == "lyon", (
        "La valeur de la clé 'city' doit être 'Lyon'."
    )


@test_checker_var
def check_dict_3(d):
    assert "sector" not in d.keys(), (
        "Le dictionnaire actuel comporte encore une clé 'sector'."
    )
    assert d == {"name": "EcoTech", "employees": 45, "revenue": 1250000}, (
        "Le dictionnaire doit avoir les clés 'name', \n'employees' (45 employés désormais), et 'revenue'."
    )
