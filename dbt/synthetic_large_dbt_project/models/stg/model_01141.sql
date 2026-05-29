{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00702') }},
        {{ ref('model_00232') }},
        {{ ref('model_00427') }}
)
select id, 'model_01141' as name from sources
