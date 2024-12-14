
import pandas as pd
import numpy as np

file = 'C://Users//hilpp//OneDrive//Työpöytä//BDBI//TASK5//AB_NYC_2019.csv'
df = pd.read_csv(file)
df.describe()
#####################################
"TEHTÄVÄ 1A"
clifton_mean_price = df[df['neighbourhood_group'] == 'Staten Island'].groupby('neighbourhood')['price'].mean()['Clifton']
print(f"The mean price in Clifton neighbourhood is: {clifton_mean_price}")

"TEHTÄVÄ 1B"
harlem_private_rooms = df[(df['neighbourhood'] == 'Harlem') & (df['room_type'] == 'Private room')].shape[0]
print(f"The number of private rooms in Harlem is: {harlem_private_rooms}")

"TEHTÄVÄ 1C"
hosts_with_multiple_private_rooms = df[(df['neighbourhood'] == 'Harlem') & (df['room_type'] == 'Private room')].groupby('host_id').filter(lambda x: len(x) > 1)['host_id'].nunique()
print(f"The number of hosts in Harlem with more than one private room is: {hosts_with_multiple_private_rooms}")

####################################
"TEHTÄVÄ 2A JA B"

def filter_airbnb(df, neighbourhood, max_price, room_type):
    """
    Filters Airbnb DataFrame based on user-given parameters.

    Args:
        df (pd.DataFrame): the original Airbnb DataFrame.
        neighbourhood (str): the neighbourhood to filter by.
        max_price (int): the maximum price for the rental.
        room_type (str): the type of room to filter by.

    Returns:
        pd.DataFrame: filtered DataFrame.
    """
    # First let's apply filters
    filtered_df = df[(df['neighbourhood'] == neighbourhood) &
                     (df['price'] <= max_price) &
                     (df['room_type'] == room_type)]
    
    # Then let's apply if-else condition
    if len(filtered_df) == 0:
        print("No matching results")
        return None
    else:
        cheapest_alternatives = filtered_df.nsmallest(10, 'price')[['host_name', 'neighbourhood', 'price', 'minimum_nights']]
        return filtered_df, cheapest_alternatives
    
#Here's an example:   
filtered_result, cheapest_alternatives = filter_airbnb(df, 'Harlem', 150, 'Private room')

if filtered_result is not None:
    print("Matching Results:")
    print(filtered_result)

    print("\nCheapest Alternatives:")
    print(cheapest_alternatives)
#############################################
"TEHTÄVÄ 3A JA B"

#First I will filter the needed data from original dataframe:
summary_table = df[df['room_type'] == 'Entire home/apt'].groupby('neighbourhood').agg({
    'price': 'mean',
    'id': 'count',
    'host_id': 'nunique'
})

# Next I will filter neighbourhoods with five or more places:
summary_table = summary_table[summary_table['id'] >= 5]

# Next I want to rename the columns in order to match the assignment illustration: 
summary_table.columns = ['Average price', 'Number of places', 'Number of hosts']

# 2a: I want to find the most expensive neighbourhood:
most_expensive_neighbourhood = summary_table['Average price'].idxmax()
most_expensive_price = summary_table['Average price'].max()

# 2b: I want to find neighbourhood with highest [Number of places]/[Number of hosts] -ratio: 
summary_table['Places to Hosts Ratio'] = summary_table['Number of places'] / summary_table['Number of hosts']
highest_ratio_neighbourhood = summary_table['Places to Hosts Ratio'].idxmax()
highest_ratio_value = summary_table['Places to Hosts Ratio'].max()

# Lets then print the summary table and answer to the questions: 
print(summary_table)

print(f"\nThe most expensive neighbourhood is {most_expensive_neighbourhood} with an average price of {most_expensive_price}")
print(f"The neighbourhood with the highest [Number of places]/[Number of hosts] ratio is {highest_ratio_neighbourhood} with a ratio of {highest_ratio_value}")














