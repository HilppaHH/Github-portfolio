
file2 = 'C://Users//hilpp//OneDrive//Työpöytä//BDBI//TASK 5 PYTHON 2//hotel_reviews.csv'
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score, recall_score, precision_score


############################################################################### 2A JA B
# Step 1: Load and preprocess the dataset
df = pd.read_csv(file2)


# Step 2: Convert existing ratings to a 0-5 scale
df['reviews.rating'] = df['reviews.rating'] * 5 / max(df['reviews.rating'])

# Remove rows with missing ratings
df = df.dropna(subset=['reviews.rating'])

# Fill missing text data with empty string
df['reviews.text'] = df['reviews.text'].fillna('')

# Step 3: Build a prediction model
# Combine 'reviews.text' and 'reviews.title' for text input
df['combined_text'] = df['reviews.text'] + ' ' + df['reviews.title'].fillna('')

# Convert ratings to classes (0 to 5)
df['rating_class'] = df['reviews.rating'].apply(lambda x: round(x))

# Split data into training and testing sets
X_train, X_test, y_train, y_test = train_test_split(df['combined_text'], df['rating_class'], test_size=0.2, random_state=42)

# Convert text data to TF-IDF vectors
tfidf_vectorizer = TfidfVectorizer(max_features=5000)
X_train_tfidf = tfidf_vectorizer.fit_transform(X_train)
X_test_tfidf = tfidf_vectorizer.transform(X_test)

# Train a logistic regression classification model
model = LogisticRegression(max_iter=1000)
model.fit(X_train_tfidf, y_train)

# Step 4: Evaluate the model's performance
y_pred = model.predict(X_test_tfidf)

accuracy = accuracy_score(y_test, y_pred)
recall = recall_score(y_test, y_pred, average='weighted')
precision = precision_score(y_test, y_pred, average='weighted')

print(f'Accuracy: {accuracy}')
print(f'Recall: {recall}')
print(f'Precision: {precision}')


############################################################################## 2C JA D
df_missing = pd.read_csv(file2)
# Filter out rows with missing grades
df_missing = df_missing[df_missing['reviews.rating'].isnull()]

# Combine 'reviews.text' and 'reviews.title' for text input
df_missing['combined_text'] = df_missing['reviews.text'] + ' ' + df_missing['reviews.title'].fillna('')

# Convert text data to TF-IDF vectors
X_missing_tfidf = tfidf_vectorizer.transform(df_missing['combined_text'])

# Predict ratings
predicted_ratings = model.predict(X_missing_tfidf)

# Plot a histogram of predicted grades
import matplotlib.pyplot as plt

plt.hist(predicted_ratings, bins=[0, 1, 2, 3, 4, 5], edgecolor='k')
plt.xlabel('Predicted Rating')
plt.ylabel('Frequency')
plt.title('Histogram of Predicted Ratings')
plt.show()

# Calculate the mean value of predictions
mean_prediction = predicted_ratings.mean()
print(f"Mean Predicted Rating: {mean_prediction:.2f}")

# Categorize the rating scale
def categorize_rating(rating):
    if rating <= 1:
        return 'poor'
    elif rating <= 3:
        return 'ok'
    else:
        return 'excellent'

# Apply categorization
#df_missing['predicted_category'] = df_missing['predicted_rating'].apply(categorize_rating)
df_missing['predicted_category'] = predicted_ratings
df_missing['predicted_category'] = df_missing['predicted_category'].apply(categorize_rating)

# Plot a histogram of predicted grade categories
plt.hist(df_missing['predicted_category'], edgecolor='k')
plt.xlabel('Predicted Rating Category')
plt.ylabel('Frequency')
plt.title('Histogram of Predicted Rating Categories')
plt.show()