{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00395') }},
        {{ ref('model_00236') }},
        {{ ref('model_00389') }}
)
select id, 'model_01134' as name from sources
