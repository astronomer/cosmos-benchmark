{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01568') }},
        {{ ref('model_01577') }},
        {{ ref('model_02078') }}
)
select id, 'model_02389' as name from sources
