{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01000') }},
        {{ ref('model_01289') }},
        {{ ref('model_01023') }}
)
select id, 'model_02112' as name from sources
