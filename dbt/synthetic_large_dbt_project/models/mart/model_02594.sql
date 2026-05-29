{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02018') }},
        {{ ref('model_02155') }}
)
select id, 'model_02594' as name from sources
