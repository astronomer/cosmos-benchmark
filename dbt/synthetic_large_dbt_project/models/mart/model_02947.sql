{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02133') }},
        {{ ref('model_02194') }}
)
select id, 'model_02947' as name from sources
