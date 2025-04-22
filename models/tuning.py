from sklearn.model_selection import GridSearchCV
from sklearn.ensemble import RandomForestClassifier

def tune_model(X, y):
    param_grid = {'n_estimators': [100, 200], 'max_depth': [10, 20, None]}
    clf = GridSearchCV(RandomForestClassifier(), param_grid, cv=3)
    clf.fit(X, y)
    return clf.best_estimator_
