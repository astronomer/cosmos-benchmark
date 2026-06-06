{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01107') }},
        {{ ref('model_01245') }},
        {{ ref('model_01293') }}
)
select id, 'model_02180' as name from sources
