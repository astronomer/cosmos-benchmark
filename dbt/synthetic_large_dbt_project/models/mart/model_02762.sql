{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01638') }},
        {{ ref('model_01671') }}
)
select id, 'model_02762' as name from sources
