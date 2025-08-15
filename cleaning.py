# 'AppID', 'Name', 'Release date', 'Required age', 'Price','Estimated owners', 'User score', 'Positive', 'Negative', 'Score rank', 'Recommendations', 'Average playtime forever', 'Categories', 'Genres', 'Tags'
# 'Peak CCU', 'Discount', 'Achievements', 'DLC count', 'Header image', 'Website', 'Notes', 'Support url', 'Support email', 'Windows', 'Mac', 'Linux', 'Metacritic score', 'Metacritic url',  'Average playtime two weeks', 'Median playtime forever', 'Median playtime two weeks', 'Developers', 'Publishers', 'Screenshots', 'Movies'

import pandas as pd

columns_to_keep = [
    'AppID', 'Name', 'Release date', 'Required age', 'Price','Estimated owners', 'User score', 
    'Positive', 'Negative', 'Score rank', 'Recommendations', 'Average playtime forever', 
    'Categories', 'Genres', 'Tags'
]

df = pd.read_csv("games.csv", usecols=columns_to_keep, encoding="latin1", low_memory=False)

# try:
#     df = pd.read_csv("games.csv", usecols=columns_to_keep, encoding="latin1", low_memory=False)
# except ValueError:
#     df = pd.read_csv("games.csv", encoding="latin1", low_memory=False)
#     df = df[[col for col in columns_to_keep if col in df.columns]]


df.to_csv("steam_data_cleaned.csv", index=False, encoding="utf-8")

print("complete'")
