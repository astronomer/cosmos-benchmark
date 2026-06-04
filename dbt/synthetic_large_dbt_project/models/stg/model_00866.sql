{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00571') }},
        {{ ref('model_00185') }},
        {{ ref('model_00300') }}
)
select id, 'model_00866' as name from sources
