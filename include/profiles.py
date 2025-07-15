"Contains profile mappings used in the project"

from cosmos import ProfileConfig
from cosmos.profiles import GoogleCloudServiceAccountDictProfileMapping

bigquery_db = ProfileConfig(
    profile_name="bigquery_db",
    target_name="dev",
    profile_mapping=GoogleCloudServiceAccountDictProfileMapping(
        conn_id="bigquery_conn",
        # Dataset for Airflow 2 Deployment
        profile_args={"project": "astronomer-dag-authoring", "dataset": "fhir_airflow2"},
        # Dataset for Airflow 3 Deployment
        # profile_args={"project": "astronomer-dag-authoring", "dataset": "fhir_airflow3"},
    )
)
