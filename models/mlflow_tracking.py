# models/mlflow_tracking.py

import mlflow
import mlflow.sklearn
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
import pandas as pd

# Function to log the model using MLflow
def log_model_with_mlflow():
    # Load data
    data = pd.read_csv('data/raw/your_data.csv')
    X = data.drop('target', axis=1)
    y = data['target']
    
    # Train-test split
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)
    
    # Train model
    model = RandomForestClassifier()
    model.fit(X_train, y_train)
    
    # Log model
    mlflow.start_run()
    mlflow.sklearn.log_model(model, 'random_forest_model')
    mlflow.log_params({'n_estimators': 100})
    
    # End the MLflow run
    mlflow.end_run()
