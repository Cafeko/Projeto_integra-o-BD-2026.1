"""
Script para análise diagnóstica e comparativa das colunas
dos arquivos em data/.

Requisitos aplicados:
- Leitura com `nrows=1` para carregar apenas o cabeçalho
- `sep=';'` e `encoding='iso-8859-1'`
- Comparações 2024->2025 e 2025->2026 usando sets

Use: python scripts/compare_columns.py
"""
from pathlib import Path
import pandas as pd
import sys


CSV_FILES = [
    Path("data/samp-2024.csv"),
    Path("data/samp-2025.csv"),
    Path("data/samp-2026.csv"),
]


def read_columns(path: Path):
    if not path.exists():
        print(f"Arquivo não encontrado: {path}")
        return []
    try:
        df = pd.read_csv(path, sep=';', encoding='iso-8859-1', nrows=1)
        return list(df.columns)
    except Exception as e:
        print(f"Erro ao ler {path}: {e}")
        return []


def compare_and_print(cols_a, cols_b, label_a, label_b):
    set_a = set(cols_a)
    set_b = set(cols_b)

    added = sorted(list(set_b - set_a))
    removed = sorted(list(set_a - set_b))

    print(f"\nComparação: {label_a} -> {label_b}")
    print(f"{label_a}: {len(cols_a)} colunas | {label_b}: {len(cols_b)} colunas")

    if added:
        print(f"\nColunas novas em {label_b} (presentes em {label_b} e ausentes em {label_a}):")
        for c in added:
            print(f"  + {c}")
    else:
        print(f"\nNenhuma coluna nova em {label_b} em relação a {label_a}.")

    if removed:
        print(f"\nColunas removidas/renomeadas em {label_b} (presentes em {label_a} e ausentes em {label_b}):")
        for c in removed:
            print(f"  - {c}")
    else:
        print(f"\nNenhuma coluna removida/renomeada em {label_b} em relação a {label_a}.")


def main():
    cols = {}
    labels = ["2024", "2025", "2026"]

    for path, label in zip(CSV_FILES, labels):
        cols[label] = read_columns(path)

    # Comparações pedidas: 2024 vs 2025, 2025 vs 2026
    compare_and_print(cols.get("2024", []), cols.get("2025", []), "2024", "2025")
    compare_and_print(cols.get("2025", []), cols.get("2026", []), "2025", "2026")


if __name__ == "__main__":
    main()
