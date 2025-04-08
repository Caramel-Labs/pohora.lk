# Agent settings
AGENT_VERBOSITY = True

# Pickled model paths
CROP_MODEL = "models/random_forest.pkl"
CROP_ENCODER_MODEL = "models/encoder.pkl"
FERTILIZER_MODEL = "models/fertilizer_recommender_decision_tree.pkl"
FERTILIZER_ENCODER_MODEL = "models/label_encoder.pkl"


# Make module safely exportable
if __name__ == "__main__":
    pass
