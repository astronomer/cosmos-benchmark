{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02215') }},
        {{ ref('model_01717') }}
)
select id, 'model_02276' as name from sources
