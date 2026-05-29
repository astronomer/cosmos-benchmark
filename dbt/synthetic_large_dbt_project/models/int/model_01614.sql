{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01385') }},
        {{ ref('model_01384') }}
)
select id, 'model_01614' as name from sources
