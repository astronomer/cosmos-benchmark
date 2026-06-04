{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01179') }},
        {{ ref('model_01134') }},
        {{ ref('model_01071') }}
)
select id, 'model_01975' as name from sources
