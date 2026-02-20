-- Project: Hospital Management Analytics
-- Platform: Google BigQuery
-- Author: Israel Favour Joseph    
-- -------------------------------------------------------------------------------------
    CREATE OR REPLACE VIEW 
`hospital-management-487322.hospital_data.hospital_analytical_view` AS

SELECT
    -- Appointment Core
    a.appointment_id,
    a.appointment_date,
    EXTRACT(YEAR FROM a.appointment_date) AS year,
    EXTRACT(MONTH FROM a.appointment_date) AS month,
    FORMAT_DATE('%Y-%m', a.appointment_date) AS year_month,
    a.status AS appointment_status,
    a.reason_for_visit AS visit_reason,

    -- Patient
    p.patient_id,
    p.gender,
    p.insurance_provider,
    p.registration_date,

    -- Doctor
    d.doctor_id,
    d.specialization,
    d.years_experience,
    d.hospital_branch,

    -- Treatment
    t.treatment_id,
    t.treatment_date,
    t.treatment_type,
    t.description,
    t.cost AS treatment_cost,

    -- Billing
    b.amount AS revenue,
    b.payment_method,
    b.payment_status

FROM `hospital-management-487322.hospital_data.appointments` a

LEFT JOIN `hospital-management-487322.hospital_data.patients` p
    ON a.patient_id = p.patient_id

LEFT JOIN `hospital-management-487322.hospital_data.doctors` d
    ON a.doctor_id = d.doctor_id

LEFT JOIN `hospital-management-487322.hospital_data.treatments` t
    ON a.appointment_id = t.appointment_id

LEFT JOIN `hospital-management-487322.hospital_data.billing` b
    ON t.treatment_id = b.treatment_id;
