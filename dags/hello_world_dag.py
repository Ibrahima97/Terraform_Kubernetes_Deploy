from airflow import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime, timedelta
import json

default_args={
    'email': ['airflow@example.com'],
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 3,
    'retry_delay': timedelta(minutes=5),
}

def helloWorld():
    print("Hello World!")
# test azure devops sync
def dump_json():
    data = {
    "message": "Hello, World!"
    }
 
    file_path = "hello_world.json"
 
    try:
        with open(file_path, "w") as json_file:
            json.dump(data, json_file, indent=4)
        print(f"JSON file '{file_path}' created successfully!")
    except Exception as e:
        print(f"An error occurred: {e}")

with DAG(
    'hello_world_dag_azure',
    default_args=default_args,
    description='Hello, World! using Airflow',
    schedule_interval="@once",
    start_date=datetime(2023, 10, 30),
    tags=['helloworld'],
) as dag:
    print_task = PythonOperator(
        task_id="task_hello_world",
        python_callable=dump_json
    )

print_task
