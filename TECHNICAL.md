# Technical Documentation

This document describes the technical architecture, data pipeline, and machine learning methodology behind the **upper-limb-rehab-dashboard**. For the full academic treatment, see the [Master's thesis](https://teses.usp.br/teses/disponiveis/55/55134/tde-21052025-142316/pt-br.html) (GUTIERRES, 2024).

## System Overview

The system follows a three-stage pipeline: **Collection**, **Processing**, and **Visualization**.

```
Collection (e-puzzle AR game)
    │
    ▼
Processing (signal filtering + ML clustering)
    │
    ▼
Visualization (interactive Panel dashboard)
```

A client-server architecture transfers data from the AR rehabilitation game to a server where it is processed and visualized through a web-based dashboard. Healthcare professionals can access the dashboard to monitor patient progress and support clinical decision-making.

## Data Collection: e-puzzle

Motion data is captured by **e-puzzle**, an augmented reality jigsaw puzzle game designed for upper limb motor rehabilitation. e-puzzle is an evolution of the GesturePuzzle/GestureControl system (Brandao et al., 2018), developed at LISI (Laboratory of Integrable Systems) at PUC-Campinas in collaboration with BRAINN (Brazilian Institute for Neuroscience and Neurotechnology).

The game uses an RGB camera (webcam) to track patient body movements without wearable sensors. Patients solve a jigsaw puzzle by moving their arms, exercising shoulder articulations across three anatomical planes (coronal, sagittal, transversal). Each session generates a CSV file with timestamped joint angle measurements.

### CSV Data Schema

Each row in a session file represents a frame captured during the exercise:

| Column | Description |
|---|---|
| `time` | Timestamp |
| `shoulderLangle`, `shoulderRangle` | Left/right shoulder angles (degrees) |
| `shoulderLTransv`, `shoulderRTransv` | Left/right shoulder transversal angles |
| `elbowLangle`, `elbowRangle` | Left/right elbow angles |
| `kneeLangle`, `kneeRangle` | Left/right knee angles |
| `hipLangle`, `hipRangle` | Left/right hip angles |

## Signal Processing

### Savitzky-Golay Filter

Raw joint angle data contains noise from the sensing process and irregular patient movements. The dashboard applies a **Savitzky-Golay digital filter** (window size 51, polynomial order 3) to smooth the signal while preserving important features such as peaks and waveform shape.

The filter fits a polynomial to a sliding window of data points using least-squares regression, producing a smoothed output that maintains the signal's peaks and inflection points — critical for identifying maximum range of motion.

### Peak Detection

After filtering, **peak detection** (`scipy.signal.find_peaks`) identifies local maxima in the joint angle signal, representing points of maximum range of motion during the exercise. Peak prominences are calculated to distinguish significant movement peaks from minor fluctuations. Peaks below a configurable threshold (default: 45 degrees) are filtered out.

## Machine Learning Pipeline

### Feature Engineering

For each session, the following statistical features are extracted from the 8 selected joint angle columns:

- **Mean** — average angle across the session
- **Median** — robust central tendency (less sensitive to outliers than mean)
- **Variance** — dispersion of movement data within the session

This produces a feature vector of 24 dimensions (8 joints x 3 statistics) per session.

### Dimensionality Reduction: PCA

**Principal Component Analysis** (PCA) reduces the 24-dimensional feature space to **5 principal components** that capture 88.14% of the total variance:

| Component | Explained Variance |
|---|---|
| PC1 | 39.34% |
| PC2 | 23.56% |
| PC3 | 15.24% |
| PC4 | 10.06% |
| PC5 | 8.99% |

PCA is applied as an unsupervised preprocessing step to eliminate redundancy among correlated joint angle features and improve clustering performance.

### Clustering: K-Means

**K-Means** clustering (k=3) is applied to the PCA-reduced data. The optimal number of clusters was determined using both the **Elbow method** (minimizing within-cluster sum of squared errors) and the **Jump method** (analyzing rate of change in WCSS), both converging on k=3.

The three clusters represent distinct movement profiles:

| Cluster | Movement Profile |
|---|---|
| **Cluster 0** | Satisfactory range of motion in upper limbs. High variance suggests diverse movement patterns — possibly sporadic or less predictable movements. |
| **Cluster 1** | Highest median joint angles across most features. Moderate variance indicates larger, more frequent, and consistent movement patterns. |
| **Cluster 2** | Lowest median values with least variation. Data concentrated around the mean — indicates limited range of motion in both upper and lower limbs. |

### Alternative: Self-Organizing Maps (SOM)

The thesis also evaluates **Self-Organizing Maps** as an alternative clustering method. SOM was tested with 3 clusters for comparison with K-Means. While the cluster compositions differed slightly, the most significant differentiating features remained the knee and elbow angles in both methods.

## Dashboard Architecture

```
User ──► Data (CSV upload) ──► Processing ──► Widgets ──► Layout
  ▲                                                         │
  └──────────────── Dashboard (updates reactively) ◄────────┘
```

The dashboard is built with **Panel** (HoloViz) using the `BootstrapTemplate` layout, and consists of three tabs:

### Main Tab
- **Plotly interactive plots** showing Savitzky-Golay filtered signals for all uploaded sessions
- Left and right limb angles displayed separately
- Peak markers overlaid on the signal curves
- Supports multi-session comparison with color-coded traces

### Details Tab
- **Matplotlib overlay plot** showing left and right angles with peak prominences for a single selected session
- **Plotly box plots** for statistical distribution of the selected limb (left and right)
- **Cluster prediction** — applies the pre-trained PCA + K-Means pipeline to classify the selected session into one of the three movement clusters

### Documentation Tab
- Cluster descriptions explaining each movement profile
- Reference charts showing median and variance distributions across clusters

## Pre-trained Models

Two pre-trained scikit-learn models are included:

- `modelo_pca.joblib` — PCA model (5 components) fitted on the training dataset
- `unsupervised-jigsaw_puzzle.joblib` — K-Means model (k=3) trained on PCA-reduced features

These models are loaded at startup and applied to new session data for real-time cluster prediction.

## Technology Stack

| Component | Technology |
|---|---|
| Dashboard framework | Panel 1.9.x (HoloViz) |
| Interactive plots | Plotly 6.x |
| Static plots | matplotlib 3.10.x |
| Data processing | pandas, NumPy |
| Signal processing | SciPy (Savitzky-Golay filter, peak detection) |
| Machine learning | scikit-learn (PCA, K-Means) |
| Model persistence | joblib |
| Containerization | Podman/Docker (Fedora-based) |
| Python | 3.12+ |

## References

- GUTIERRES, P. **Treatment support system for upper limb motor rehabilitation**. 2024. Dissertation (MSc) — ICMC-USP, Sao Carlos. [Full text](https://teses.usp.br/teses/disponiveis/55/55134/tde-21052025-142316/pt-br.html)
- BRANDAO, A. F. et al. GestureControl: Gesture recognition system. *Computational Science — ICCS 2018*, Springer, 2018.
