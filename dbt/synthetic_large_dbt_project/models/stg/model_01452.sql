{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00133') }},
        {{ ref('model_00608') }},
        {{ ref('model_00702') }}
)
select id, 'model_01452' as name from sources
