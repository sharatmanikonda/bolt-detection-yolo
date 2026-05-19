"""
YOLO11 Bolt Detection Training Script
Use Case: Automobile Manufacturing

Requirements:
pip install ultralytics opencv-python matplotlib

Dataset:
Download a YOLO-format bolt detection dataset from:
https://universe.roboflow.com/search?q=bolt+detection

Recommended workflow:
1. Download dataset in YOLOv8 format
2. Extract dataset
3. Update DATA_YAML path below
4. Download yolo models from here
   https://docs.ultralytics.com/models/yolo11
5. Run the script
"""

from ultralytics import YOLO
import cv2
import matplotlib.pyplot as plt

import os
os.getcwd()

# =========================================================
# CONFIGURATION
# =========================================================

# Path to your dataset YAML
DATA_YAML = r"D:\Instilit\2025\Coporate Requirements\ExcelR\Cummins\DL&GenAI\Bolt Detection_Yolo_Model\dataset/data.yaml"

# YOLO11 model
MODEL_NAME = "yolo11n.pt"

# Test image after training
TEST_IMAGE = "bolt_test.jpg"

# =========================================================
# LOAD MODEL

model = YOLO(MODEL_NAME)

# =========================================================
# TRAIN MODEL

model.train(
    data=DATA_YAML,
    epochs=5,
    imgsz=640,
    batch=16,
    device="cpu",
    project="bolt_detection_project",
    name="yolo11_bolt_detector"
)

print("Training completed!")

# =========================================================
# VALIDATE MODEL

metrics = model.val()

print("\nValidation Metrics:")
print(f"mAP50: {metrics.box.map50:.4f}")
print(f"mAP50-95: {metrics.box.map:.4f}")
print(f"Precision: {metrics.box.mp:.4f}")
print(f"Recall: {metrics.box.mr:.4f}")

# =========================================================
# LOAD TRAINED MODEL

trained_model = YOLO(
    "bolt_detection_project/yolo11_bolt_detector3/weights/best.pt"
)

# =========================================================
# INFERENCE ON TEST IMAGE

results = trained_model.predict(
    source=TEST_IMAGE,
    conf=0.4,
    save=True
)

# Verify the detections
print(results[0].boxes)

# =========================================================
# DISPLAY RESULTS

annotated = results[0].plot()

annotated_rgb = cv2.cvtColor(annotated, cv2.COLOR_BGR2RGB)

plt.figure(figsize=(12, 8))
plt.imshow(annotated_rgb)
plt.title("YOLO11 Bolt Detection")
plt.axis("off")
plt.show()

# =========================================================
# PRINT DETECTIONS
print("\nDetected Objects:\n")

for box in results[0].boxes:
    cls_id = int(box.cls[0])
    conf = float(box.conf[0])

    print(f"Class: {trained_model.names[cls_id]}")
    print(f"Confidence: {conf:.2f}")
    print("-" * 30)

print("Inference completed!")
##############


















