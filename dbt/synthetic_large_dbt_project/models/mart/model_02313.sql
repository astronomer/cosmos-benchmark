{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02098') }},
        {{ ref('model_01670') }},
        {{ ref('model_02139') }}
)
select id, 'model_02313' as name from sources
