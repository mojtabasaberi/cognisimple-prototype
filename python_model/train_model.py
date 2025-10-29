
---

### 2. `python_model/train_model.py`

**محتوا:**
```python
import pandas as pd
import numpy as np
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score
import joblib

# تولید داده‌های آموزشی نمونه (۵۰ نفر)
np.random.seed(42)
data = {
    'response_time': np.random.uniform(0.5, 2.5, 50),  # زمان پاسخ (ثانیه)
    'accuracy': np.random.uniform(0.6, 1.0, 50),       # دقت پاسخ
    'attention_level': np.random.choice(['ضعیف', 'متوسط', 'خوب'], 50)
}
df = pd.DataFrame(data)

# آموزش مدل
X = df[['response_time', 'accuracy']]
y = df['attention_level']
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

model = RandomForestClassifier(n_estimators=100, random_state=42)
model.fit(X_train, y_train)

# دقت مدل
y_pred = model.predict(X_test)
accuracy = accuracy_score(y_test, y_pred)
print(f"دقت مدل: {accuracy * 100:.1f}%")

# ذخیره مدل برای استفاده در اپ
joblib.dump(model, 'model_attention.pkl')
print("مدل ذخیره شد: model_attention.pkl")
