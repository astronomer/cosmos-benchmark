{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00909') }},
        {{ ref('model_01206') }}
)
select id, 'model_01866' as name from sources
