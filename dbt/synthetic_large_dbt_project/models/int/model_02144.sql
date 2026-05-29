{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00802') }},
        {{ ref('model_01371') }},
        {{ ref('model_01233') }}
)
select id, 'model_02144' as name from sources
