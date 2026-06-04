{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00205') }},
        {{ ref('model_00530') }},
        {{ ref('model_00015') }}
)
select id, 'model_01018' as name from sources
