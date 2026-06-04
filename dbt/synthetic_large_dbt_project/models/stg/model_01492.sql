{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00702') }},
        {{ ref('model_00730') }},
        {{ ref('model_00158') }}
)
select id, 'model_01492' as name from sources
