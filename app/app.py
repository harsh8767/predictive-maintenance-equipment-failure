# import streamlit as st
# import pandas as pd
# import joblib

# if "prediction_history" not in st.session_state:
#     st.session_state.prediction_history = []

# if "clear_history" not in st.session_state:
#     st.session_state.clear_history = False


# MODEL_PATH = "app/model/gradient_boosting_pipeline.joblib"

# model = joblib.load(MODEL_PATH)

# st.set_page_config(
#     page_title="Machine Failure Prediction",
#     page_icon="⚙️",
#     layout="wide"
# )

# st.title("⚙️ Predictive Maintenance Intelligence")
# st.caption(
#     "Machine failure risk assessment powered by Gradient Boosting"
# )

# st.info(
#     "Enter machine operating conditions in the sidebar, "
#     "then run the prediction to assess failure risk."
# )

# st.divider()

# with st.sidebar:
#     st.header("⚙️ Machine Inputs")

#     machine_type = st.selectbox(
#         "Machine Type",
#         ["L", "M", "H"]
#     )

#     air_temperature = st.number_input(
#         "Air Temperature (K)",
#         min_value=295.3,
#         max_value=304.5,
#         value=300.0
#     )

#     process_temperature = st.number_input(
#         "Process Temperature (K)",
#         min_value=305.7,
#         max_value=313.8,
#         value=310.0
#     )

#     rotational_speed = st.number_input(
#         "Rotational Speed (RPM)",
#         min_value=1168,
#         max_value=2886,
#         value=1500
#     )

#     torque = st.number_input(
#         "Torque (Nm)",
#         min_value=3.8,
#         max_value=76.6,
#         value=40.0
#     )

#     tool_wear = st.number_input(
#         "Tool Wear (min)",
#         min_value=0,
#         max_value=253,
#         value=100
#     )

# st.divider()

# st.subheader("🤖 Model Performance")

# m1, m2, m3, m4, m5 = st.columns(5)

# m1.metric("Accuracy", "99%")
# m2.metric("Precision", "92%")
# m3.metric("Recall", "68%")
# m4.metric("F1 Score", "78%")
# m5.metric("ROC-AUC", "96.5%")


# if st.button("Predict Failure Risk", type="primary"):

#     st.subheader("Operating Conditions")

#     m1, m2, m3 = st.columns(3)

#     m1.metric("Machine Type", machine_type)
#     m1.metric("Rotational Speed", f"{rotational_speed} RPM")

#     m2.metric("Torque", f"{torque:.1f} Nm")
#     m2.metric("Tool Wear", f"{tool_wear} min")

#     m3.metric("Air Temperature", f"{air_temperature:.1f} K")
#     m3.metric("Process Temperature", f"{process_temperature:.1f} K")

#     input_data = pd.DataFrame({
#         "ProductID": ["APP001"],
#         "Type": [machine_type],
#         "Air temperature [K]": [air_temperature],
#         "Process temperature [K]": [process_temperature],
#         "Rotational speed [rpm]": [rotational_speed],
#         "Torque [Nm]": [torque],
#         "Tool wear [min]": [tool_wear]
#     })

#     prediction = model.predict(input_data)[0]
#     probability = model.predict_proba(input_data)[0][1]

#     risk_factors = []

#     if torque >= 50:
#         risk_factors.append("High torque")

#     if tool_wear >= 150:
#         risk_factors.append("High tool wear")

#     if rotational_speed <= 1400:
#         risk_factors.append("Low rotational speed")

#     if process_temperature - air_temperature >= 10:
#         risk_factors.append("High temperature difference")

#     if not st.session_state.clear_history:

#         st.session_state.prediction_history.append({
#         "Machine Type": machine_type,
#         "Speed (RPM)": rotational_speed,
#         "Torque (Nm)": torque,
#         "Tool Wear (min)": tool_wear,
#         "Failure Probability": f"{probability:.1%}",
#         "Prediction": "Failure" if prediction == 1 else "Normal"
#     })

#     st.session_state.clear_history = False

#     st.subheader("Prediction Result")

#     if probability >= 0.70:
#         st.error("🔴 HIGH FAILURE RISK")
#         st.warning("Recommended action: Inspect machine before the next operating cycle.")
#     elif probability >= 0.30:
#         st.warning("🟡 MEDIUM FAILURE RISK")
#         st.info("Recommended action: Monitor machine conditions and schedule inspection.")
#     else:
#         st.success("🟢 LOW FAILURE RISK")
#         st.info("Recommended action: Continue normal operation and routine monitoring.")

#     st.metric(
#         "Failure Probability",
#         f"{probability:.1%}"
#     )

#     st.progress(
#     float(probability),
#     text=f"Failure probability: {probability:.1%}"
#     )

#     st.divider()
#     st.metric(
#         "Predictions This Session",
#         len(st.session_state.prediction_history)
#     )

#     st.subheader("Prediction History")

#     if st.session_state.prediction_history:
#         history_df = pd.DataFrame(st.session_state.prediction_history)
#         st.dataframe(
#         history_df,
#         use_container_width=True,
#         hide_index=True
#     )
#     else:
#         st.info("No predictions recorded yet.")


#     st.subheader("Key Risk Factors")

#     if risk_factors:
#         for factor in risk_factors:
#             st.warning(f"⚠️ {factor}")
#     else:
#         st.success("No major risk factors detected from the entered conditions.")

#     if st.button("🗑️ Clear Prediction History"):
#         st.session_state.prediction_history = []
#         st.session_state.clear_history = True
#         st.rerun()


import streamlit as st
import pandas as pd
import joblib

# -----------------------------
# Session State
# -----------------------------
if "prediction_history" not in st.session_state:
    st.session_state.prediction_history = []

# -----------------------------
# Load Model
# -----------------------------
MODEL_PATH = "app/model/gradient_boosting_pipeline.joblib"
model = joblib.load(MODEL_PATH)

# -----------------------------
# Page Configuration
# -----------------------------
st.set_page_config(
    page_title="Machine Failure Prediction",
    page_icon="⚙️",
    layout="wide"
)

# -----------------------------
# Header
# -----------------------------
st.title("⚙️ Predictive Maintenance Intelligence")
st.caption(
    "Machine failure risk assessment powered by Gradient Boosting"
)

st.info(
    "Enter machine operating conditions in the sidebar, "
    "then run the prediction to assess failure risk."
)

# -----------------------------
# Sidebar Inputs
# -----------------------------
with st.sidebar:
    st.header("⚙️ Machine Inputs")

    machine_type = st.selectbox(
        "Machine Type",
        ["L", "M", "H"]
    )

    air_temperature = st.number_input(
        "Air Temperature (K)",
        min_value=295.3,
        max_value=304.5,
        value=300.0
    )

    process_temperature = st.number_input(
        "Process Temperature (K)",
        min_value=305.7,
        max_value=313.8,
        value=310.0
    )

    rotational_speed = st.number_input(
        "Rotational Speed (RPM)",
        min_value=1168,
        max_value=2886,
        value=1500
    )

    torque = st.number_input(
        "Torque (Nm)",
        min_value=3.8,
        max_value=76.6,
        value=40.0
    )

    tool_wear = st.number_input(
        "Tool Wear (min)",
        min_value=0,
        max_value=253,
        value=100
    )

    predict_button = st.button(
        "🔮 Predict Failure Risk",
        type="primary",
        use_container_width=True
    )

    clear_button = st.button(
        "🗑️ Clear Prediction History",
        use_container_width=True
    )

# -----------------------------
# Clear History
# -----------------------------
if clear_button:
    st.session_state.prediction_history = []
    st.success("Prediction history cleared.")
    st.rerun()

# -----------------------------
# Model Performance
# -----------------------------
st.divider()

st.subheader("🤖 Model Performance")

m1, m2, m3, m4, m5 = st.columns(5)

m1.metric("Accuracy", "99%")
m2.metric("Precision", "92%")
m3.metric("Recall", "68%")
m4.metric("F1 Score", "78%")
m5.metric("ROC-AUC", "96.5%")

# -----------------------------
# Prediction
# -----------------------------
if predict_button:

    input_data = pd.DataFrame({
        "ProductID": ["APP001"],
        "Type": [machine_type],
        "Air temperature [K]": [air_temperature],
        "Process temperature [K]": [process_temperature],
        "Rotational speed [rpm]": [rotational_speed],
        "Torque [Nm]": [torque],
        "Tool wear [min]": [tool_wear]
    })

    prediction = model.predict(input_data)[0]
    probability = model.predict_proba(input_data)[0][1]

    # -------------------------
    # Operating Conditions
    # -------------------------
    st.subheader("Operating Conditions")

    c1, c2, c3 = st.columns(3)

    c1.metric("Machine Type", machine_type)
    c1.metric("Rotational Speed", f"{rotational_speed} RPM")

    c2.metric("Torque", f"{torque:.1f} Nm")
    c2.metric("Tool Wear", f"{tool_wear} min")

    c3.metric("Air Temperature", f"{air_temperature:.1f} K")
    c3.metric("Process Temperature", f"{process_temperature:.1f} K")

    # -------------------------
    # Risk Factors
    # -------------------------
    risk_factors = []

    if torque >= 50:
        risk_factors.append("High torque")

    if tool_wear >= 150:
        risk_factors.append("High tool wear")

    if rotational_speed <= 1400:
        risk_factors.append("Low rotational speed")

    if process_temperature - air_temperature >= 10:
        risk_factors.append("High temperature difference")

    # -------------------------
    # Save Prediction
    # -------------------------
    st.session_state.prediction_history.append({
        "Machine Type": machine_type,
        "Speed (RPM)": rotational_speed,
        "Torque (Nm)": torque,
        "Tool Wear (min)": tool_wear,
        "Failure Probability": f"{probability:.1%}",
        "Prediction": "Failure" if prediction == 1 else "Normal"
    })

    # -------------------------
    # Prediction Result
    # -------------------------
    st.subheader("Prediction Result")

    if probability >= 0.70:
        st.error("🔴 HIGH FAILURE RISK")
        st.warning(
            "Recommended action: Inspect machine before "
            "the next operating cycle."
        )

    elif probability >= 0.30:
        st.warning("🟡 MEDIUM FAILURE RISK")
        st.info(
            "Recommended action: Monitor machine conditions "
            "and schedule inspection."
        )

    else:
        st.success("🟢 LOW FAILURE RISK")
        st.info(
            "Recommended action: Continue normal operation "
            "and routine monitoring."
        )

    st.metric(
        "Failure Probability",
        f"{probability:.1%}"
    )

    st.progress(
        float(probability),
        text=f"Failure probability: {probability:.1%}"
    )

    # -------------------------
    # Risk Factors
    # -------------------------
    st.subheader("Key Risk Factors")

    if risk_factors:
        for factor in risk_factors:
            st.warning(f"⚠️ {factor}")
    else:
        st.success(
            "No major risk factors detected from the "
            "entered conditions."
        )

# -----------------------------
# Prediction History
# -----------------------------
st.divider()

st.metric(
    "Predictions This Session",
    len(st.session_state.prediction_history)
)

st.subheader("Prediction History")

if st.session_state.prediction_history:

    history_df = pd.DataFrame(
        st.session_state.prediction_history
    )

    st.dataframe(
        history_df,
        use_container_width=True,
        hide_index=True
    )

else:
    st.info("No predictions recorded yet.")

st.divider()

st.caption(
    "Predictive Maintenance Equipment Failure | "
    "Gradient Boosting Model | Streamlit Application"
)