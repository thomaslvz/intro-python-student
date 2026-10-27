"""
Ne pas modifier ce fichier. Il contient les tests automatisés pour
guider les étudiant.e.s dans les notebook.
"""

import traceback
import pandas as pd

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


@test_checker_func
def check_calculate_power(f):
    assert f(2, 0) == 1
    assert f(5, 2) == 25
    assert f(3, 3) == 27
    assert f(3, 4) == 81


@test_checker_func
def check_elasticity(f):
    assert abs(f(100, 95, 10, 11) - (-0.5)) < 1e-9


@test_checker_func
def check_separate_tags(f):
    assert f("python data science") == "python, data, science"
    assert f("Bonjour merci") == "Bonjour, merci"


@test_checker_var
def check_squares(li, name="'squares'"):
    assert isinstance(li, list), f"La variable {name} doit être une liste."
    assert len(li) > 0, f"La liste {name} ne doit pas être vide."
    assert li == [(i + 1) ** 2 for i in range(10)], (
        f"La liste '{name}' doit contenir 1, 4, 9, etc."
    )


@test_checker_var
def check_digits(s):
    pass


@test_checker_var
def check_numbers(li):
    pass


@test_checker_var
def check_squares_dict(d):
    assert isinstance(d, dict), (
        "La variable 'squares_dict' doit être un dictionnaire valide."
    )
    assert len(d) > 0, "'squares_dict' ne doit pas être vide !"
    assert list(d.values()) == [(i + 1) ** 2 for i in range(10)], (
        "Les valeurs de 'squares_dict' doivent être  1, 4, 9, etc."
    )


@test_checker_func
def check_financial_result(f):
    assert [f(0, 0), f(1000, 0), f(0, 1000)] != [None, None, None], (
        "La fonction doit RENVOYER un résultat : actuellement, elle ne renvoit rien."
    )
    assert f(0, 0) is not None, (
        "Si les revenus sont égaux coûts, la fonction doit RENVOYER un résultat."
    )
    assert f(1000, 0) is not None, (
        "Si les revenus sont supérieurs aux coûts, la fonction doit RENVOYER un résultat."
    )
    assert f(0, 1000) is not None, (
        "Si les revenus sont inférieurs aux coûts, la fonction doit RENVOYER un résultat."
    )
    assert isinstance(f(0, 0), str), (
        "La fonction doit renvoyer une chaîne de caractères (str)"
    )
    assert f(1000, 1000).lower() == "loss", (
        "Si les recettes sont égales au coût, doit-on afficher loss ou profit ?"
    )
    assert f(1000, 500).lower() == "profit", (
        "Si les recettes sont supérieures au coûts, doit-on afficher loss ou profit ?"
    )
    assert f(500, 1000).lower() == "loss", (
        "Si les recettes sont inférieures au coût, doit-on afficher loss ou profit ?"
    )


@test_checker_func
def check_classify_revenue(f):
    assert f(800) is not None, (
        "La fonction doit RENVOYER un résultat : utilisez la clause 'return'."
    )
    assert isinstance(f(800), str), "La fonction doit renvoyer une chaîne de caractères"
    assert f(800).lower() == "low", "La fonction ne renvoie pas le bon résultat."
    assert f(1000).lower() == "medium", (
        "La fonction doit renvoyer 'medium' si le CA est entre 1000 inclus et 5000 exclu"
    )
    assert f(1500).lower() == "medium", "La fonction ne renvoie pas le bon résultat."
    assert f(5000).lower() == "high", (
        "La fonction doit renvoyer 'medium' si le CA est entre 1000 inclus et 5000 exclu"
    )
    assert f(9500).lower() == "high", "La fonction ne renvoie pas le bon résultat."


@test_checker_func
def check_add_eligibility(f):
    client = {"name": "Hector", "age": 25, "student": False, "country": "France"}
    assert f(client) is not None, (
        "La fonction doit RENVOYER un résultat : utilisez la clause 'return'."
    )
    assert isinstance(f(client), dict), "La fonction doit renvoyer un dictionnaire."
    clients = [
        {"name": "Hector", "age": 25, "student": False, "country": "France"},
        {"name": "Alice", "age": 29, "student": True, "country": "France"},
        {"name": "Bob", "age": 30, "student": False, "country": "France"},
        {"name": "Charlie", "age": 22, "student": True, "country": "UK"},
        {"name": "Sylvia", "age": 33, "student": False, "country": "Spain"},
    ]
    assert "is_eligible" in f(clients[0]).keys(), (
        "Le dictionnaire renvoyé par la fonction doit contenir la clé 'is_eligible'."
    )
    assert isinstance(f(clients[0])["is_eligible"], bool), (
        "La valeur associée à la clé 'is_eligible' doit être un booléen."
    )
    assert f(clients[0]).get("is_eligible", ""), (
        "Testez votre fonction sur un client français, étudiant, de 25 ans."
    )
    assert f(clients[1]).get("is_eligible", ""), (
        "Testez votre fonction sur un client français, non étudiant, de 29 ans."
    )
    assert not f(clients[2]).get("is_eligible", ""), (
        "Testez votre fonction sur un client français, étudiant, de 30 ans."
    )
    assert not f(clients[3]).get("is_eligible", ""), (
        "Testez votre fonction sur un client non français, étudiant, de 22 ans."
    )
    assert not f(clients[4]).get("is_eligible", ""), (
        "Testez votre fonction sur un client non français, non étudiant, de 33 ans."
    )


@test_checker_var
def check_clients(clients):
    assert clients != [
        {"name": "Hector", "age": 25, "student": False, "country": "France"},
        {"name": "Alice", "age": 29, "student": True, "country": "France"},
        {"name": "Bob", "age": 30, "student": False, "country": "France"},
        {"name": "Charlie", "age": 22, "student": True, "country": "UK"},
        {"name": "Sylvia", "age": 33, "student": False, "country": "Spain"},
    ], "Vous devez modifier la liste 'clients'."
    assert len(clients) == 5, (
        "Vous devez avoir 5 personnes dans votre liste 'clients', comme c'était le cas au départ."
    )
    assert pd.DataFrame(clients).get("name").to_list() == [
        "Hector",
        "Alice",
        "Bob",
        "Charlie",
        "Sylvia",
    ], (
        "Dans l'ordre, les clients doivent être 'Hector', 'Alice', 'Bob', 'Charlie', 'Sylvia'"
    )
    assert pd.DataFrame(clients).get("name").isna().sum() == 0, (
        "Chaque client doit avoir un nom dans la clé 'name'."
    )
    assert pd.DataFrame(clients).get("age").isna().sum() == 0, (
        "Chaque client doit avoir un age dans la clé 'age'."
    )
    assert pd.DataFrame(clients).get("student").isna().sum() == 0, (
        "Chaque client doit avoir un statut d'étudiant dans la clé 'student'."
    )
    assert pd.DataFrame(clients).get("country").isna().sum() == 0, (
        "Chaque client doit avoir un pays de résidence dans la clé 'country'."
    )
    assert pd.DataFrame(clients).get("is_eligible").isna().sum() == 0, (
        "Après votre boucle, chaque client doit avoir un attribut 'is_eligible'."
    )
    assert pd.DataFrame(clients).get("is_eligible").dtype == "bool", (
        "Les valeurs de la clé 'is_eligible' doivent être des booléens."
    )
    assert clients[0].get("is_eligible", ""), "Hector est il éligible ?"
    assert clients[1].get("is_eligible", ""), "Alice est-elle éligible ?"
    assert not clients[2].get("is_eligible", ""), "Bob est-il éligible ?"
    assert not clients[3].get("is_eligible", ""), "Charlie est-il éligible ?"
    assert not clients[4].get("is_eligible", ""), "Sylia est-elle éligible ?"
