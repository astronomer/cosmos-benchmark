{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00170') }},
        {{ ref('model_00376') }},
        {{ ref('model_00161') }}
)
select id, 'model_00766' as name from sources
