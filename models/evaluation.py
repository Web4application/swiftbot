# models/evaluation.py

from sklearn.metrics import accuracy_score, precision_score, recall_score, f1_score

def evaluate_model_metrics(model, X_test, y_test):
    """
    Evaluate the model using multiple metrics.
    
    Parameters:
    - model: trained model object.
    - X_test: Test features.
    - y_test: True labels.
    
    Returns:
    - Dictionary containing accuracy, precision, recall, and F1 score.
    """
    predictions = model.predict(X_test)
    
    accuracy = accuracy_score(y_test, predictions)
    precision = precision_score(y_test, predictions)
    recall = recall_score(y_test, predictions)
    f1 = f1_score(y_test, predictions)
    
    metrics = {
        'accuracy': accuracy,
        'precision': precision,
        'recall': recall,
        'f1_score': f1
    }
    
    return metrics
