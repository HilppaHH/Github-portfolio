
"""

Records from Sports Tracking software Endomondo
- Terminated in 2020
- Data of a one person 2017-2020 with 3456 events stored as .json

In Python the task is to: 
MAIN TASK: Create a ML-model that forecasts the user’s next exercise type, time and, possibly, duration as well
SUB-TASK: Before the ML-model fitting, classify / label / cluster / categorize the data!


ORIGINAL VARIABLES OF DF_RES ARE (no capital letters): 
SPORT
SOURCE
CREATED_DATE
START_TIME
END_TIME
DURATION_S
DISTANCE_KM
CALORIES_KM
ALTITUDE_MIN_M
ALTITUDE_MAX_M
SPEED_AVG_KMH
ASCEND_M
DESCEND_M
START_LONG
START_LAT
END_LAT
END_LONG
HYDRATION_L


"""

import os
import json
import pandas as pd
from sklearn.preprocessing import LabelEncoder
import matplotlib.pyplot as plt
import seaborn as sns
import warnings

# Filter out FutureWarnings
warnings.simplefilter(action='ignore', category=FutureWarning)

folder = 'C://Users//hilpp//OneDrive//Työpöytä//BDBI//PRACTICAL ASSIGNMENT//PRACTICAL ASSIGNMENT-20231010//WorkoutData_2017to2020'
file_list = os.listdir(folder)





def read_file_to_df(filename):
    data = pd.read_json(filename, typ='series')
    value = []
    key = []
    for j in list(range(0, data.size)):
        if list(data[j].keys())[0] != 'points':
            key.append(list(data[j].keys())[0])
            value.append(list(data[j].items())[0][1])
            dictionary = dict(zip(key, value))
       

    if list(data[j].keys())[0] == 'points':
        try:
            start = list(list(list(data[data.size-1].items()))[0][1][0][0].items())[0][1][0]
            dictionary['start_lat'] = list(start[0].items())[0][1]
            dictionary['start_long'] = list(start[1].items())[0][1]
            dictionary['end_lat'] = list(start[0].items())[0][1]
            dictionary['end_long'] = list(start[1].items())[0][1]
        except:
            print('No detailed data recorded')
            
        
    df = pd.DataFrame(dictionary, index = [0])

    return df

# Read all files in a loop

# Create Empty DataFrame
df_res = pd.DataFrame()

# Read files to a common dataframe
for filename in file_list:
    print('\n'+filename)
    df_process = read_file_to_df(folder +'/'+ filename)
    df_res = pd.concat([df_res, df_process], 0)

df_res.reset_index(drop=True, inplace = True)







# Data Exploration:
df_res.describe()


# Check for missing values
missing_values = df_res.isnull().sum()

# Handling missing values:
# Fill missing values with the mean of the column.
df_res.fillna(df_res.mean(), inplace=True)






# Convert 'start_time' and 'end_time' to datetime objects
df_res['start_time'] = pd.to_datetime(df_res['start_time'])
df_res['end_time'] = pd.to_datetime(df_res['end_time'])

# Extract day of the week dt.day_name()
df_res['day_of_week'] = df_res['start_time'].dt.day_of_week

# Extract time of day: in order for the ML-model to predict the time of the user's next exercise.
df_res['time_of_day'] = df_res['start_time'].dt.time

# Extract month (numbers 1-12)
df_res['month'] = df_res['start_time'].dt.month

# Assuming df is your DataFrame and 'created_date' is the column name
df_res['created_date'] = pd.to_datetime(df_res['created_date'])
# Extract the year:
df_res['year'] = df_res['created_date'].dt.year

# Extract time of day in minutes
df_res['time_of_day_minutes'] = df_res['start_time'].dt.hour * 60 + df_res['start_time'].dt.minute




# Calculate duration (MINUTES). New variable duration_m creted
df_res['duration_m'] = df_res['end_time'] - df_res['start_time']
df_res['duration_m'] = df_res['duration_m'].dt.total_seconds() / 60  # Convert to minutes




# Initialize the LabelEncoder
label_encoder = LabelEncoder()
# Fit and transform the 'sport' column
df_res['sport_encoded'] = label_encoder.fit_transform(df_res['sport'])
# Display the updated DataFrame
print(df_res[['sport', 'sport_encoded']])


# Creating a new feature 'distance_per_minute'
df_res['distance_per_minute'] = df_res['distance_km'] / df_res['duration_m']


# categorize hours of the day
def categorize_time(hour):
    if 5 <= hour < 10:
        return 'MORNING'
    elif 10 <= hour < 14:
        return 'DAY'
    elif 14 <= hour < 18:
        return 'AFTERNOON'
    elif 18 <= hour < 23:
        return 'EVENING'
    else:
        return 'NIGHT'

# Apply the function to create a new column
df_res['time_category'] = df_res['start_time'].dt.hour.apply(categorize_time)

# Display the updated DataFrame
print(df_res[['start_time', 'time_category']])


# Next convert the categories to numeric format:
# Initialize the LabelEncoder
label_encoder2 = LabelEncoder()

# Fit and transform the 'sport' column
df_res['time_category_encoded'] = label_encoder2.fit_transform(df_res['time_category'])

# Display the updated DataFrame
print(df_res[['time_category', 'time_category_encoded']])





# categorize distances
def categorize_distance(distance_km):
    if distance_km < 5:
        return 'Short'
    elif 5 <= distance_km < 10:
        return 'Medium'
    elif 10 <= distance_km < 20:
        return 'Long'
    else:
        return 'Very Long'

# Assuming 'distance_km' is a column in your DataFrame
# Apply the function to create a new column
df_res['distance_category'] = df_res['distance_km'].apply(categorize_distance)

# Display the updated DataFrame
print(df_res[['distance_km', 'distance_category']])

# Next convert the categories to numeric format:
# Initialize the LabelEncoder
label_encoder3 = LabelEncoder()

# Fit and transform the 'sport' column
df_res['distance_km_category_encoded'] = label_encoder3.fit_transform(df_res['distance_category'])

# Display the updated DataFrame
print(df_res[['distance_category', 'distance_km_category_encoded']])


# categorize calories
def categorize_calories(calories):
    if calories < 100:
        return 'Low'
    elif 100 <= calories < 500:
        return 'Moderate'
    elif 500 <= calories < 1000:
        return 'High'
    else:
        return 'Very High'

# Assuming 'calories_kcal' is a column in your DataFrame
# Apply the function to create a new column
df_res['calories_category'] = df_res['calories_kcal'].apply(categorize_calories)

# Display the updated DataFrame
print(df_res[['calories_kcal', 'calories_category']])

# Next convert the categories to numeric format:
# Initialize the LabelEncoder
label_encoder4 = LabelEncoder()

# Fit and transform the 'sport' column
df_res['calories_category_encoded'] = label_encoder4.fit_transform(df_res['calories_category'])

# Display the updated DataFrame
print(df_res[['calories_category', 'calories_category_encoded']])



# categorize durations
def categorize_duration(duration_seconds):
    if duration_seconds < 1800:
        return 'Short'
    elif 1800 <= duration_seconds < 3600:
        return 'Medium'
    elif 3600 <= duration_seconds < 7200:
        return 'Long'
    else:
        return 'Very Long'

# Assuming 'duration_s' is a column in your DataFrame
# Apply the function to create a new column
df_res['duration_category'] = df_res['duration_s'].apply(categorize_duration)

# Display the updated DataFrame
print(df_res[['duration_s', 'duration_category']])

# Next convert the categories to numeric format:
# Initialize the LabelEncoder
label_encoder5 = LabelEncoder()

# Fit and transform the 'sport' column
df_res['duration_category_encoded'] = label_encoder5.fit_transform(df_res['duration_category'])

# Display the updated DataFrame
print(df_res[['duration_category', 'duration_category_encoded']])






#1. Sport Category Distribution

plt.figure(figsize=(10, 6))
df_res['sport'].value_counts().plot(kind='bar')
plt.title('Distribution of Exercise Types')
plt.xlabel('Exercise Type')
plt.ylabel('Frequency')
plt.show()

#2. Time Category Distribution

plt.figure(figsize=(10, 6))
sns.countplot(x='time_category', data=df_res)
plt.title('Distribution of Time Categories')
plt.xlabel('Time Category')
plt.ylabel('Frequency')
plt.show()

#3. Distance Category Distribution

plt.figure(figsize=(10, 6))
sns.countplot(x='distance_category', data=df_res)
plt.title('Distribution of Distance Categories')
plt.xlabel('Distance Category')
plt.ylabel('Frequency')
plt.show()

#4. Calories Category Distribution

plt.figure(figsize=(10, 6))
sns.countplot(x='calories_category', data=df_res)
plt.title('Distribution of Calories Categories')
plt.xlabel('Calories Category')
plt.ylabel('Frequency')
plt.show()

#5. Duration Category Distribution

plt.figure(figsize=(10, 6))
sns.countplot(x='duration_category', data=df_res)
plt.title('Distribution of Duration Categories')
plt.xlabel('Duration Category')
plt.ylabel('Frequency')
plt.show()

# täääääääääääääääääääääääääääääääääääääääääääääääääääääääää
plt.figure(figsize=(8, 8))
sns.scatterplot(x='distance_km', y='calories_kcal', hue='sport', data=df_res)
plt.title('Scatter Plot of Distance vs. Calories')
plt.show()


plt.figure(figsize=(10, 6))
sns.histplot(df_res['duration_m'], bins=30, kde=True)
plt.title('Distribution of Duration (minutes)')
plt.xlabel('Duration (minutes)')
plt.ylabel('Frequency')
plt.show()


g = sns.PairGrid(df_res, vars=['distance_km', 'calories_kcal', 'duration_m'], hue='sport')
g.map_diag(plt.hist)
g.map_offdiag(plt.scatter)
g.add_legend()
plt.show()

# Create a cross-tabulation table
cross_tab = pd.crosstab(df_res['time_category'], df_res['sport'])

# Plotting
plt.figure(figsize=(12, 8))
cross_tab.plot(kind='bar', stacked=True)
plt.title('Exercise Type Distribution by Time Category')
plt.xlabel('Time Category')
plt.ylabel('Frequency')
plt.show()



g = sns.FacetGrid(df_res, col='time_category', col_wrap=3, height=5)
g.map(sns.countplot, 'sport')
g.set_titles(col_template="{col_name}")
plt.subplots_adjust(top=0.9)
g.fig.suptitle('Exercise Type Distribution by Time Category')
plt.show()




# Determine the five most popular sports
top_sports = df_res['sport'].value_counts().nlargest(5).index.tolist()

# Filter the DataFrame to include only the top five sports
df_top_sports = df_res[df_res['sport'].isin(top_sports)]

# Create a cross-tabulation table
cross_tab = pd.crosstab(df_top_sports['time_category'], df_top_sports['sport'])

# Plotting with Set3 color palette
plt.figure(figsize=(12, 8))
cross_tab.plot(kind='bar', stacked=True, cmap='Set3')
plt.title('Exercise Type Distribution by Time Category (Top 5 Sports)')
plt.xlabel('Time Category')
plt.ylabel('Frequency')
plt.show()

#%%



















from sklearn.cluster import KMeans
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import silhouette_score
import matplotlib.pyplot as plt



# Step 1: Feature Selection
features_for_clustering = ['time_category_encoded', 'distance_km_category_encoded', 'duration_category_encoded','day_of_week', 'month','year','sport_encoded','calories_category_encoded']
X = df_res[features_for_clustering]

# Step 2: Standardization
scaler = StandardScaler()
X_standardized = scaler.fit_transform(X)




distortions = []
K = range(1,10)
for k in K:
    kmeanModel = KMeans(n_clusters=k)
    kmeanModel.fit(X_standardized)
    distortions.append(kmeanModel.inertia_)

plt.figure(figsize=(16,8))
plt.plot(K, distortions, 'bx-')
plt.xlabel('k')
plt.ylabel('Distortion')
plt.title('The Elbow Method showing the optimal k')
plt.show()



silhouette_scores = []
K = range(2,10)
for k in K:
    kmeanModel = KMeans(n_clusters=k)
    cluster_labels = kmeanModel.fit_predict(X_standardized)
    silhouette_avg = silhouette_score(X_standardized, cluster_labels)
    silhouette_scores.append(silhouette_avg)

plt.figure(figsize=(16,8))
plt.plot(K, silhouette_scores, 'bx-')
plt.xlabel('k')
plt.ylabel('Silhouette Score')
plt.title('Silhouette Score for each k')
plt.show()




# Step 3: Choosing Number of Clusters
num_clusters = 2

# Step 4: Applying K-means Clustering
kmeans = KMeans(n_clusters=num_clusters, random_state=0)
df_res['cluster'] = kmeans.fit_predict(X_standardized)

# Calculate the distances from centroids
distances = kmeans.transform(X_standardized)

# Find the index of the closest point
closest_cluster_index = distances.argmin(axis=0)

# Step 6: Forecasting
closest_exercise_type = df_res.loc[closest_cluster_index, 'sport']
closest_time = df_res.loc[closest_cluster_index, 'time_category']
closest_duration = df_res.loc[closest_cluster_index, 'duration_category']
print(f"The forecasted next exercise type is: {closest_exercise_type}")
print(f"The forecasted time of the next exercise is: {closest_time}")
print(f"The forecasted duration of the next exercise is: {closest_duration}")




plt.hist(df_res['cluster'], bins=num_clusters, rwidth=0.8)
plt.title('Cluster Sizes')
plt.xlabel('Cluster')
plt.ylabel('Number of Data Points')
plt.show()





###########################################


import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error

# Assuming df_res contains your preprocessed data

# Double-check the column names in your DataFrame
print(df_res.columns)

# Select relevant features
#selected_features = ['time_category_encoded', 'distance_km_category_encoded', 'duration_category_encoded', 'day_of_week', 'month', 'year', 'sport_encoded', 'calories_category_encoded']
selected_features = ['distance_per_minute']





# Ensure selected features are in the DataFrame
assert all(feature in df_res.columns for feature in selected_features), "Selected features not found in DataFrame"

# Split data into training and testing sets
X = df_res[selected_features]
y = df_res['duration_m']
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# Initialize and train the regression model
reg_model = LinearRegression()
reg_model.fit(X_train, y_train)

# Make predictions
y_pred = reg_model.predict(X_test)

# Evaluate the model
mse = mean_squared_error(y_test, y_pred)
rmse = mse**0.5

print(f"Mean Squared Error: {mse}")
print(f"Root Mean Squared Error: {rmse}")


# Visualize actual vs. predicted durations
plt.figure(figsize=(10, 6))
plt.scatter(y_test, y_pred)
plt.title('Actual vs. Predicted Durations')
plt.xlabel('Actual Duration (minutes)')
plt.ylabel('Predicted Duration (minutes)')
plt.show()









# Assuming X_type contains the selected features and y_type contains the exercise type values
y_type= df_res['sport_encoded']
X_type = df_res[['time_category_encoded', 'distance_km_category_encoded', 'duration_category_encoded', 'day_of_week', 'month', 'year', 'sport_encoded', 'calories_category_encoded']]


from sklearn.model_selection import train_test_split

# Assuming X_type and y_type have been defined as you did previously

# Split the data into training and testing sets (80% train, 20% test)
X_train_type, X_test_type, y_train_type, y_test_type = train_test_split(X_type, y_type, test_size=0.2, random_state=42)

# Initialize and train the regression model
reg_model_type = LinearRegression()
reg_model_type.fit(X_train_type, y_train_type)

# Make predictions on the test set
y_pred_type = reg_model_type.predict(X_test_type)

# Evaluate the model on the test set
mse_type = mean_squared_error(y_test_type, y_pred_type)
rmse_type = mse_type**0.5

print(f"Mean Squared Error for Exercise Type Prediction: {mse_type}")
print(f"Root Mean Squared Error for Exercise Type Prediction: {rmse_type}")


