from airflow import DAG
from airflow.utils.dates import days_ago
from datetime import datetime, timedelta
from airflow.contrib.operators.kubernetes_pod_operator import KubernetesPodOperator
from airflow.operators.dummy_operator import DummyOperator

default_args = {
     'owner': 'airflow',
    'depends_on_past': False,
    'start_date': days_ago(2),
    'email': ['airflow@example.com'],
    'email_on_failure': False,
    'email_on_retry': False,
}

dag = DAG(
    'last-testing', default_args=default_args, schedule_interval=None)

start = DummyOperator(task_id='run_this_first', dag=dag)

image = "232383674343.dkr.ecr.us-east-1.amazonaws.com/REPOSITORY_NAME:COMMIT_SHA"

tolerations = [
    {
        'key': "nvidia.com/gpu",
        'operator': 'Equal',
        'value': 'present'
     }
]

last_testing_v1 = KubernetesPodOperator(namespace='default',
                          image=image,
                          labels={"foo": "bar"},
                          name="last-test",
                          task_id="last-task",
                          get_logs=True,
                          tolerations=tolerations,
                          resources={'limit_gpu' : 1},
                          dag=dag,
                          affinity={
                            'nodeAffinity': {
                                'requiredDuringSchedulingIgnoredDuringExecution': {
                                    'nodeSelectorTerms': [{
                                        'matchExpressions': [{
                                            'key': 'cloud.google.com/gke-nodepool',
                                            'operator': 'In',
                                            'values': [
                                                'gpu-pool',
                                            ]
                                        }]
                                    }]
                                }
                            }
                        }
                          )
