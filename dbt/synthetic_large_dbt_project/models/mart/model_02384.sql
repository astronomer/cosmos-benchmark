{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01821') }},
        {{ ref('model_01869') }},
        {{ ref('model_01956') }}
)
select id, 'model_02384' as name from sources
