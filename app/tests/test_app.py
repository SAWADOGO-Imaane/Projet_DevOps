import pytest
import sys
from pathlib import Path

# Ajouter le dossier parent au path
sys.path.insert(0, str(Path(__file__).parent.parent))


def test_imports():
    """Test que les imports fonctionnent"""
    import streamlit
    import pandas
    import numpy
    assert True


def test_basic_calculation():
    """Test de calcul basique"""
    result = 2 + 2
    assert result == 4


def test_data_processing():
    """Test de traitement de données"""
    import pandas as pd
    import numpy as np
    
    df = pd.DataFrame({
        'A': np.random.randint(0, 100, 10),
        'B': np.random.uniform(0, 1, 10)
    })
    
    assert len(df) == 10
    assert list(df.columns) == ['A', 'B']


@pytest.fixture
def sample_data():
    """Fixture de données d'exemple"""
    import pandas as pd
    import numpy as np
    
    return pd.DataFrame({
        'Ventes': np.random.randint(100, 1000, 100),
        'Clients': np.random.randint(10, 100, 100),
    })


def test_sample_data(sample_data):
    """Test avec données d'exemple"""
    assert len(sample_data) == 100
    assert sample_data['Ventes'].min() >= 100
    assert sample_data['Ventes'].max() <= 1000


if __name__ == "__main__":
    pytest.main([__file__, "-v"])
