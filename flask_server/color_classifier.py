import cv2
import numpy as np

def rgb_to_hv_single(R, G, B):
    R_normalized = R / 255.0
    G_normalized = G / 255.0
    B_normalized = B / 255.0
    
    V = max(R_normalized, G_normalized, B_normalized)
    min_rgb = min(R_normalized, G_normalized, B_normalized)
    delta = V - min_rgb
    
    if delta == 0:
        H = 0
    else:
        if V == R_normalized:
            H = 60 * (((G_normalized - B_normalized) / delta) % 6)
        elif V == G_normalized:
            H = 60 * (((B_normalized - R_normalized) / delta) + 2)
        else:
            H = 60 * (((R_normalized - G_normalized) / delta) + 4)
    
    if H < 0:
        H += 360
    
    V_percent = V * 100
    return H, V_percent

def classify_season(H, V):
    if 81 <= H <= 329 and V > 50:
        return "Summer"
    elif ((0 <= H <= 80) or (330 <= H <= 360)) and V > 50:
        return "Spring"
    elif ((0 <= H <= 80) or (330 <= H <= 360)) and V <= 50:
        return "Autumn"
    elif 81 <= H <= 329 and V <= 50:
        return "Winter"
    else:
        return "Unknown Season"

def get_dominant_color(image_path):
    image = cv2.imread(image_path)
    image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
    pixels = np.float32(image.reshape(-1, 3))
    n_colors = 1
    criteria = (cv2.TERM_CRITERIA_EPS + cv2.TERM_CRITERIA_MAX_ITER, 200, 0.1)
    _, labels, centers = cv2.kmeans(
        pixels, n_colors, None, criteria, 10, cv2.KMEANS_RANDOM_CENTERS
    )
    return centers[0].astype(int)