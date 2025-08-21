# Doing this initial cleanign to remove unnecessary columns as the file is too big and hard to work with
import pandas as pd
from pathlib import Path

# Columns filtering
# 'AppID', 'Name', 'Release date', 'Required age', 'Price','Estimated owners', 'User score', 'Positive', 'Negative', 'Recommendations', 'Average playtime forever', 'Categories', 'Genres', 'Tags, 'Developers', 'Publishers''
# 'Peak CCU', 'Discount', 'Achievements', 'DLC count', 'Header image', 'Website', 'Notes', 'Score rank', 'Support url', 'Support email', 'Windows', 'Mac', 'Linux', 'Metacritic score', 'Metacritic url',  'Average playtime two weeks', 'Median playtime forever', 'Median playtime two weeks', 'Screenshots', 'Movies'

columns_to_keep = [
    'AppID', 'Name', 'Release date', 'Required age', 'Price','Estimated owners', 'User score', 
    'Positive', 'Negative', 'Recommendations', 'Average playtime forever', 
    'Categories', 'Genres', 'Tags', 'Developers', 'Publishers'
]

# Path resolving
script_path = Path(__file__).resolve().parent
data_path = script_path.parent / "data" / "games.csv"

# Reading the CSV file with specified columns and saving it as a new CSV file
df = pd.read_csv(data_path, usecols=columns_to_keep, encoding="utf-8", low_memory=False)
df.to_csv(data_path, index=False, encoding="utf-8")

print("complete'")