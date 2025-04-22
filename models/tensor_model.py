# models/model.py

import tensorflow as tf
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense
from tensorflow.keras.optimizers import Adam
from tensorflow.keras.callbacks import EarlyStopping
import pandas as pd
import numpy as np

# Function to load and preprocess the data
def load_data(file_path):
    data = pd.read_csv(file_path)
    X = data.drop('target', axis=1).values  # Features
    y = data['target'].values  # Labels
    return X, y

# Function to define the model
def create_model(input_shape):
    model = Sequential([
        Dense(64, activation='relu', input_shape=input_shape),
        Dense(32, activation='relu'),
        Dense(1, activation='sigmoid')  # Assuming binary classification
    ])
    model.compile(optimizer=Adam(), loss='binary_crossentropy', metrics=['accuracy'])
    return model

# Function to train the model
def train_model(X_train, y_train, X_val, y_val):
    model = create_model((X_train.shape[1],))
    
    early_stopping = EarlyStopping(monitor='val_loss', patience=5, restore_best_weights=True)
    
    model.fit(X_train, y_train, validation_data=(X_val, y_val), epochs=50, batch_size=32, callbacks=[early_stopping])
    
    return model

# Function to save the model
def save_model(model, model_filename):
    model.save(model_filename)

# Main function to load data, train, and save the model
def main():
    # Load data
    X, y = load_data('data/raw/your_data.csv')
    
    # Split data into training and validation sets
    from sklearn.model_selection import train_test_split
    X_train, X_val, y_train, y_val = train_test_split(X, y, test_size=0.2, random_state=42)
    
    # Train the model
    model = train_model(X_train, y_train, X_val, y_val)
    
    # Save the trained model
    save_model(model, 'models/trained_model/keras_model.h5')

if __name__ == '__main__':
    main()
