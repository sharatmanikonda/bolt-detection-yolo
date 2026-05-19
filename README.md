# 🔩 Bolt Detection using YOLO11

> **Use Case:** Automobile Manufacturing — Detecting good and bad bolts using computer vision.

## 📋 Project Overview

This project uses **Ultralytics YOLO11** to detect and classify bolts as either `boltbad` or `boltgood` in manufacturing environments. The model is trained on a custom dataset from Roboflow.

## 🚀 Getting Started

### Prerequisites

```bash
pip install ultralytics opencv-python matplotlib
```

### Dataset

Download a YOLO-format bolt detection dataset from:
- [Roboflow Universe - Bolt Detection](https://universe.roboflow.com/search?q=bolt+detection)
- Or use the dataset already configured in `dataset/data.yaml`

### Model Weights

Download YOLO11 models from:
- https://docs.ultralytics.com/models/yolo11

Place the `.pt` file in the project root (e.g., `yolo11n.pt`).

## 🏋️ Training

Run the training script:

```bash
python yolo11_bolt_detection.py
```

The training configuration:
- **Model:** YOLO11n (nano)
- **Epochs:** 5
- **Image Size:** 640
- **Batch:** 16
- **Device:** CPU

## 📊 Dataset

- **Classes:** `boltbad`, `boltgood` (2 classes)
- **Source:** [Roboflow - Bolt Dataset](https://universe.roboflow.com/yoloscrew/bolt-rwpu9/dataset/1)
- **License:** CC BY 4.0

## 📁 Project Structure

```
├── yolo11_bolt_detection.py   # Main training & inference script
├── dataset/                    # Dataset (train/val/test splits)
│   ├── data.yaml
│   ├── train/
│   ├── valid/
│   └── test/
├── new/                        # Sample test images
├── bolt_detection_project/     # Training outputs (gitignored)
├── .gitignore
└── README.md
```

## 🧪 Inference

After training, the script automatically runs inference on a test image and displays the results with bounding boxes and confidence scores.

## 📈 Metrics

The validation step reports:
- **mAP50**
- **mAP50-95**
- **Precision**
- **Recall**

## 📄 License

This project is licensed under CC BY 4.0.

---

*Built with [Ultralytics YOLO11](https://github.com/ultralytics/ultralytics)*
