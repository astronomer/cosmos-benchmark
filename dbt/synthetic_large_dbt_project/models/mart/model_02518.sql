{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01821') }},
        {{ ref('model_01549') }},
        {{ ref('model_02047') }}
)
select id, 'model_02518' as name from sources
