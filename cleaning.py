import pandas as pd

# Try to read the raw CSV, logging issues
try:
    df = pd.read_csv("games.csv", quoting=1, on_bad_lines='warn', encoding='utf-8')
except Exception as e:
    print("Failed to load:", e)

# Inspect shape
print("Raw shape:", df.shape)

# Optional cleaning examples:
df.columns = [col.strip() for col in df.columns]
df = df.dropna(subset=['AppID', 'Name'])  # ensure key fields exist
df['Release date'] = pd.to_datetime(df['Release date'], errors='coerce')
df = df[df['Release date'].notna()]  # drop rows with bad dates

# Save cleaned version
df.to_csv("games_cleaned.csv", index=False)




