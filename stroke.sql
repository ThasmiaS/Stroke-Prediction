DROP TABLE IF EXISTS strokes
CREATE TABLE strokes (
    id SERIAL PRIMARY KEY,
    gender VARCHAR(10),
    age INTEGER,
    hypertension BOOLEAN,
    heart_disease BOOLEAN,
    ever_married VARCHAR(3),
    work_type VARCHAR(20),
    residence_type VARCHAR(6),
    avg_glucose_level FLOAT,
    bmi FLOAT NULL,
    smoking_status VARCHAR(15),
    stroke BOOLEAN
);
-- stroke cases by age, for male and female (line graph)
SELECT age, 
	COUNT(CASE WHEN gender = 'Male' AND stroke = 'true' THEN 1 END) AS male_stroke_cases,
    COUNT(CASE WHEN gender = 'Female' AND stroke = 'false' THEN 1 END) AS female_stroke_cases
FROM strokes
GROUP BY age
ORDER BY age ASC

-- 
select count(*), residence_type
from strokes
WHERE stroke = 'true'
group by residence_type
 -- BMI vs stroke cases (bar graph)
SELECT
    CASE
        WHEN bmi IS NULL THEN 'Unknown'
        WHEN bmi < 18.5 THEN 'Underweight'
        WHEN bmi >= 18.5 AND bmi < 25 THEN 'Normal'
        WHEN bmi >= 25 AND bmi < 30 THEN 'Overweight'
        ELSE 'Obese'
    END AS bmi_bin,
    COUNT(CASE WHEN stroke = 'true' THEN 1 END) AS stroke_count
FROM strokes
GROUP BY bmi_bin
ORDER BY bmi_bin;

-- stroke cases with a combination of diseases and smoking (bar graph)
SELECT hypertension, heart_disease, smoking_status, COUNT(*) AS stroke_count
FROM strokes
WHERE stroke = 'true'
GROUP BY hypertension, heart_disease, smoking_status
ORDER BY hypertension, heart_disease, smoking_status;

-- stroke cases for varying glucose levels
SELECT count(CASE WHEN stroke = 'true' THEN 1 END) as stroke_cases, avg_glucose_level
FROM strokes
GROUP BY avg_glucose_level
ORDER BY avg_glucose_level

-- stroke cases by smoking status
SELECT CASE
        WHEN smoking_status = 'unknown' THEN 'Unknown'
        WHEN smoking_status = 'never smoked' THEN 'never smoked'
        WHEN smoking_status = 'formerly smoked' THEN 'formerly smoked'
        WHEN smoking_status = 'smokes' THEN 'smokes'
        ELSE 'unknown'
    END as smoking_status,
    COUNT(CASE WHEN stroke = 'true' THEN 1 END) AS stroke_cases
FROM strokes
GROUP BY smoking_status

-- BANs for those who had a stroke
-- avg glucose
SELECT ROUND(AVG(avg_glucose_level)::numeric,1) as average_glucose_stroke
FROM strokes
WHERE stroke = 'true'
-- avg BMI
SELECT ROUND(AVG(bmi)::numeric,1) as average_bmi_stroke
FROM strokes
WHERE stroke = 'true'
-- % hypertension
SELECT ROUND((COUNT(*) FILTER (WHERE stroke = 'true'  AND hypertension = 'true') * 100.0 / COUNT(*) FILTER (WHERE stroke = 'true')),1) AS percent_hypertension
FROM strokes

-- % hypertension
SELECT ROUND((COUNT(*) FILTER (WHERE stroke = 'true'  AND heart_disease = 'true') * 100.0 / COUNT(*) FILTER (WHERE stroke = 'true')),1) AS percent_heart_disease
FROM strokes
-- Genders
SELECT count(*)
FROM strokes
WHERE gender = 'Female' AND stroke = 'true'
-- % smokers
SELECT ROUND((COUNT(*) FILTER (WHERE stroke = 'true'  AND smoking_status = 'smokes') * 100.0 / COUNT(*) FILTER (WHERE stroke = 'true')),1) AS percent_smoker
FROM strokes
-- % former smoker
SELECT ROUND((COUNT(*) FILTER (WHERE stroke = 'true'  AND smoking_status = 'formerly smoked') * 100.0 / COUNT(*) FILTER (WHERE stroke = 'true')),1) AS percent_smoked
FROM strokes

SELECT *
from strokes