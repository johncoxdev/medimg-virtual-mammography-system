import numpy as np
import matplotlib.pyplot as plt

class XRaySimulator:
    def __init__(self, size=100):
        self.size = size
        self.phantom = None
        self.source_distance = 100
        self.detector_distance = 10
        self.beam_energy = 20  # keV
        self.angle = 0  # degrees
        
        # Attenuation coefficients (μ) for different materials at default energy
        self.mu_values = {
            'air': 0.0,
            'tissue': 0.5,
            'dense_tissue': 0.8
        }
    
    def generate_2d_test_phantom(self):
        """Generate a 2D test phantom with simple geometric shapes"""
        self.phantom = np.zeros((self.size, self.size))
        
        # Background tissue
        center = self.size // 2
        radius = self.size // 4
        y, x = np.ogrid[-center:self.size-center, -center:self.size-center]
        mask = x*x + y*y <= radius*radius
        self.phantom[mask] = self.mu_values['tissue']
        
        # Add a denser region for testing
        small_radius = radius // 2
        dense_mask = x*x + y*y <= small_radius*small_radius
        self.phantom[dense_mask] = self.mu_values['dense_tissue']
        
        # Debug display
        plt.figure(figsize=(8, 8))
        plt.imshow(self.phantom, cmap='gray')
        plt.title("Generated 2D Phantom")
        plt.colorbar()
        plt.show(block=True)
        
        return self.phantom

    def apply_beam_attenuation(self, beam_angle=0):
        """Apply Beer-Lambert law for X-ray attenuation"""
        if self.phantom is None:
            raise ValueError("Phantom must be generated first")
            
        # Rotate phantom if angle isn't 0
        if beam_angle != 0:
            rotated_phantom = np.rot90(self.phantom, k=int(beam_angle/90))
        else:
            rotated_phantom = self.phantom
            
        # Calculate path length through material (simplified)
        path_length = 1.0
        
        # Apply Beer-Lambert law
        I0 = 1.0  # initial intensity
        attenuation = I0 * np.exp(-rotated_phantom * path_length)
        
        # Debug display
        plt.figure(figsize=(8, 8))
        plt.imshow(attenuation, cmap='gray')
        plt.title(f"Attenuation at {beam_angle} degrees")
        plt.colorbar()
        plt.show(block=True)
        
        return attenuation

def test_simulator():
    print("Creating simulator...")
    simulator = XRaySimulator(size=100)
    
    print("Generating phantom...")
    phantom = simulator.generate_2d_test_phantom()
    
    print("Testing different angles...")
    angles = [0, 45, 90]
    for angle in angles:
        print(f"Testing angle: {angle} degrees")
        simulator.angle = angle
        attenuation = simulator.apply_beam_attenuation(angle)
        
        # Force display for each angle
        plt.figure(figsize=(8, 8))
        plt.imshow(attenuation, cmap='gray')
        plt.title(f"Projection at {angle} degrees")
        plt.colorbar()
        plt.show(block=True)

if __name__ == "__main__":
    print("Starting test...")
    test_simulator()