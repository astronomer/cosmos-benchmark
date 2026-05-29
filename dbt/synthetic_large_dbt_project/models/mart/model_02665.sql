{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01872') }},
        {{ ref('model_01590') }}
)
select id, 'model_02665' as name from sources
