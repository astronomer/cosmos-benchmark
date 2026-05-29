{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01188') }},
        {{ ref('model_00936') }}
)
select id, 'model_01826' as name from sources
